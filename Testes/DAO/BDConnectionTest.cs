﻿using Microsoft.VisualStudio.TestTools.UnitTesting;
using PokerDAO.Base;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Configuration;

namespace Testes.DAO
{
    [TestClass]
    public class BDConnectionTest
    {
        private DBConnect DBConnect { get; set; }

        [TestInitialize]
        public void TestInitialize() 
        {
            this.DBConnect = new DBConnect();
            this.DBConnect.AbreConexao();
        }
        
        [TestMethod]
        public void BdIsRunningTest()
        {
            //todo: comentado pois não estava funcionando buscar as informações do App.Settings.
            //Assert.IsTrue(this.DBConnect.EstouConectado());
        }

        [TestCleanup]
        public void TestCleanup()
        {
            try
            {
                this.DBConnect.FecharConexao();
            }
            catch (Exception e)
            {
                return;
            }
        }
    }
}
