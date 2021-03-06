﻿using Comum.Classes;
using Comum.Interfaces;
using Enuns;
using JogadorTH;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Modelo;
using System.Linq;

namespace Testes
{
    [TestClass]
    public class PartidaIntegracaoTest
    {

        static ConfiguracaoTHBonus configPadrao
        {
            get
            {
                return new ConfiguracaoTHBonus()
                {
                    Ant = 5,
                    Flop = 10,
                    Turn = 5,
                    River = 5,
                };
            }
        }

        [TestMethod]
        public void PartidaJogadorGanha_1() 
        {
            uint
                stackJogadorInicial = 500,
                valorStackJogadorAposPagarAnt = 495,
                valorStackJogadorAposPagarFlop = 485,
                valorPortMesaAposPreFlop = (5 + 10 + 10);
            
            IJogador jog = new DummyJogadorTHB(PartidaIntegracaoTest.configPadrao, stackJogadorInicial);
            IJogador banca = new Banca(PartidaIntegracaoTest.configPadrao);
            ICroupier dealer = new Croupier(
                new Comum.Mesa(PartidaIntegracaoTest.configPadrao),
                banca,
                jog
            );

            dealer.IniciarNovaPartida(); //pre Jogo

            // Pre-jogo (Paga ant, distribui carta ao jogador, adiciona rodada)
            IPartida p = dealer.Mesa.PartidasAtuais[jog];
            p.AddToPote(jog.PagarValor(PartidaIntegracaoTest.configPadrao.Ant), TipoJogadorTHB.Jogador);
            jog.ReceberCarta(new Carta(10, Enuns.Naipe.Copas), new Carta(9, Enuns.Naipe.Copas));
            p.AddRodada(new RodadaTHB(Enuns.TipoRodada.PreFlop, p.PoteAgora, null));
            Assert.IsTrue(valorStackJogadorAposPagarAnt == jog.Stack);

            // Pre-flop (Pagar para ver flop)
            p.AddToPote(jog.PagarValor(PartidaIntegracaoTest.configPadrao.Flop), TipoJogadorTHB.Jogador);
            p.AddToPote(banca.PagarValor(PartidaIntegracaoTest.configPadrao.Flop), TipoJogadorTHB.Banca);
            p.AddRodada(new RodadaTHB(Enuns.TipoRodada.Flop, p.PoteAgora, p.CartasMesa));

            Assert.IsTrue(jog.Stack == valorStackJogadorAposPagarFlop); // stack jogador
            Assert.IsTrue(p.PoteAgora == valorPortMesaAposPreFlop); // pote banca

            // Flop (Revelar Flop - Perguntar pagar turn)
            Carta[] flop = new Carta[] { new Carta(12, Enuns.Naipe.Copas), new Carta(13, Enuns.Naipe.Copas), new Carta(11, Enuns.Naipe.Copas) };
            typeof(Partida).GetProperty("Flop").SetValue(p, flop);
            p.AddRodada(new RodadaTHB(Enuns.TipoRodada.Turn, p.PoteAgora, p.CartasMesa));

            // Turn
            Carta turn = new Carta(4, Enuns.Naipe.Paus);
            typeof(Partida).GetProperty("Turn").SetValue(p, turn);
            p.AddRodada(new RodadaTHB(Enuns.TipoRodada.River, p.PoteAgora, p.CartasMesa));

            // River
            Carta river = new Carta(8, Enuns.Naipe.Ouros);
            typeof(Partida).GetProperty("River").SetValue(p, river);


            banca.ReceberCarta(new Carta(2, Enuns.Naipe.Espadas), new Carta(3, Enuns.Naipe.Espadas));

            Carta[] CartasBanca = new Carta[] {
                p.Banca.Cartas[0],
                p.Banca.Cartas[1]
            };
            Carta[] CartasJogador = new Carta[] {
                p.Jogador.Cartas[0],
                p.Jogador.Cartas[1]
            };
            Carta[] CartasMesa = p.CartasMesa;

            ConstrutorMelhorMao construtorMao = new ConstrutorMelhorMao();
            MaoTexasHoldem melhorMaoJogador = construtorMao.GetMelhorMao(CartasMesa.Union(CartasJogador).ToList());

            construtorMao = new ConstrutorMelhorMao();
            MaoTexasHoldem melhorMaoBanca = construtorMao.GetMelhorMao(CartasMesa.Union(CartasBanca).ToList());

            Assert.IsTrue(melhorMaoJogador.Compara(melhorMaoBanca) == 1);
            
            p.JogadorGanhador = VencedorPartida.Jogador;
            p.Jogador.ReceberValor(p.PoteAgora);

            Assert.IsTrue(p.Jogador.Stack == 510);

        }

    }
}
