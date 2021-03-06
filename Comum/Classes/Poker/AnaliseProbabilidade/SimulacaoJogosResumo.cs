﻿using Comum.Interfaces;
using Comum.Interfaces.AnaliseProbabilidade;
using System;
using System.Collections.Generic;
using System.Text;

namespace Comum.Classes.Poker.AnaliseProbabilidade
{
    public class SimulacaoJogosResumo : ISimulacaoJogosResumo
    {
        public int Id { get; set; }
        public uint QuantidadeJogosSimuladosPretendidos { get; set; }
        public uint QuantidadeJogosSimulados { get; set; } = 0;
        public uint QuantidadeJogosGanhos { get; set; }
        public uint QuantidadeJogosPerdidos { get; set; }
        public uint QuantidadeJogosEmpatados { get; set; }
        public uint StackInicial { get; set; }
        public uint StackFinal { get; set; }
        public string DescricaoInteligencia { get; set; }
        public IAcaoProbabilidade AcaoProbabilidade { get; set; }
    }
}
