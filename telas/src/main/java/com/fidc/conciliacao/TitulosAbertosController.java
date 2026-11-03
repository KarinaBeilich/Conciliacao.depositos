package com.fidc.conciliacao;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Arrays;
import java.util.List;

@Controller
@RequestMapping("/titulos-abertos")
public class TitulosAbertosController {

    @GetMapping
    public String exibirTela(Model model) {
        // Criando dados genéricos para preencher a tabela de títulos em aberto
        List<TituloAbertoDTO> titulos = Arrays.asList(
            new TituloAbertoDTO("1000001", "4 || ICF", "19/10/2026", "SACADO EXEMPLO 01 LTDA", "000001/001", "17/09/2026", "90000001", "010993", "236", "400,00", "0,00", "0,00", "CEDENTE EXEMPLO A LTDA", "00.000.000/0001-11", "000000000001", "400,00"),
            new TituloAbertoDTO("1000002", "4 || ICF", "22/10/2026", "SACADO EXEMPLO 02 LTDA", "000002/001", "02/10/2026", "90000002", "010993", "236", "550,00", "10,00", "20,00", "CEDENTE EXEMPLO A LTDA", "00.000.000/0001-12", "000000000002", "550,00"),
            new TituloAbertoDTO("1000003", "4 || ICF", "22/10/2026", "SACADO EXEMPLO 03 LTDA", "000003/001", "31/07/2026", "90000003", "010993", "231", "21.800,00", "0,00", "00,00", "CEDENTE EXEMPLO B LTDA", "00.000.000/0001-13", "000000000003", "21.800,00"),
            new TituloAbertoDTO("1000004", "4 || ICF", "22/10/2026", "SACADO EXEMPLO 04 LTDA", "000004/001", "25/09/2026", "90000004", "010993", "236", "1.600,00", "00,00", "00,00", "CEDENTE EXEMPLO C LTDA", "00.000.000/0001-14", "000000000004", "1.600,00"),
            new TituloAbertoDTO("1000005", "4 || ICF", "11/10/2026", "SACADO EXEMPLO 05 LTDA", "000005/001", "18/05/2026", "90000005", "660193", "231", "8.700,00", "00,00", "00,00", "CEDENTE EXEMPLO D LTDA", "00.000.000/0001-15", " ", "8.700,00"),
            new TituloAbertoDTO("1000006", "4 || ICF", "26/01/2027", "SACADO EXEMPLO 06 LTDA", "000006/001", "29/10/2026", "90000006", "010193", "231", "6.600,00", "50,00", "00,00", "CEDENTE EXEMPLO E LTDA", "00.000.000/0001-16", " ", "6.600,00"),
            new TituloAbertoDTO("1000007", "4 || ICF", "25/12/2026", "SACADO EXEMPLO 07 LTDA", "000007/001", "30/10/2026", "90000007", "010193", "231", "8.700,00", "50,00", "20,00", "CEDENTE EXEMPLO F LTDA", "00.000.000/0001-17", " ", "8.700,00"),
            new TituloAbertoDTO("1000008", "4 || ICF", "27/11/2026", "SACADO EXEMPLO 08 LTDA", "000008/001", "30/10/2026", "90000008", "010193", "231", "1.600,00", "50,00", "20,00", "CEDENTE EXEMPLO G LTDA", "00.000.000/0001-18", " ", "1.600,00"),
            new TituloAbertoDTO("1000009", "4 || ICF", "18/12/2026", "SACADO EXEMPLO 09 LTDA", "000009/001", "30/10/2026", "90000009", "010193", "231", "700,00", "00,00", "00,00", "CEDENTE EXEMPLO G LTDA", "00.000.000/0001-19", " ", "700,00"),
            new TituloAbertoDTO("1000010", "4 || ICF", "11/12/2026", "SACADO EXEMPLO 10 LTDA", "000010/001", "30/10/2026", "90000010", "010193", "231", "1.350,00", "00,00", "20,00", "CEDENTE EXEMPLO G LTDA", "00.000.000/0001-20", " ", "1.350,00"),
            new TituloAbertoDTO("1000011", "12 || FN3", "21/10/2026", "SACADO EXEMPLO 11 LTDA", "000011/001", "08/07/2026", "90000011", "010993", "122375", "900,00", "0,00", "0,00", "CEDENTE EXEMPLO H LTDA", "00.000.000/0001-21", "000000000011", "900,00"),
            new TituloAbertoDTO("1000012", "14 || GEN", "23/10/2026", "SACADO EXEMPLO 12 LTDA", "000012/001", "15/07/2026", "90000012", "010193", "140231", "600,00", "12,00", "00,00", "CEDENTE EXEMPLO I LTDA", "00.000.000/0001-22", "000000000012", "600,00"),
            new TituloAbertoDTO("1000013", "2 || TV1", "11/12/2026", "SACADO EXEMPLO 13 LTDA", "000004/003", "27/10/2026", "90000013", "010401", "16609", "25000,00", "0,00", "14,00", "CEDENTE EXEMPLO EPSILON LTDA", "00.000.000/0001-23", " ", "25.000,00")
            
        );

        
        model.addAttribute("titulos", titulos);

        return "titulos-abertos";
    }

    
    public static class TituloAbertoDTO {
        private String ingcodigo;
        private String empresa;
        private String vencimento;
        private String sacado;
        private String documento;
        private String dataOpe;
        private String operacao;
        private String idg;
        private String locCobr;
        private String valor;
        private String abatimento;
        private String desconto;
        private String cedente;
        private String cpfCnpjSacado;
        private String nossoNumero;
        private String valorLiquido;

        public TituloAbertoDTO(String ingcodigo, String empresa, String vencimento, String sacado, String documento, String dataOpe, String operacao, String idg, String locCobr, String valor, String abatimento, String desconto, String cedente, String cpfCnpjSacado, String nossoNumero, String valorLiquido) {
            this.ingcodigo = ingcodigo;
            this.empresa = empresa;
            this.vencimento = vencimento;
            this.sacado = sacado;
            this.documento = documento;
            this.dataOpe = dataOpe;
            this.operacao = operacao;
            this.idg = idg;
            this.locCobr = locCobr;
            this.valor = valor;
            this.abatimento = abatimento;
            this.desconto = desconto;
            this.cedente = cedente;
            this.cpfCnpjSacado = cpfCnpjSacado;
            this.nossoNumero = nossoNumero;
            this.valorLiquido = valorLiquido;
        }

        
        public String getIngcodigo() { return ingcodigo; }
        public String getEmpresa() { return empresa; }
        public String getVencimento() { return vencimento; }
        public String getSacado() { return sacado; }
        public String getDocumento() { return documento; }
        public String getDataOpe() { return dataOpe; }
        public String getOperacao() { return operacao; }
        public String getIdg() { return idg; }
        public String getLocCobr() { return locCobr; }
        public String getValor() { return valor; }
        public String getAbatimento() { return abatimento; }
        public String getDesconto() { return desconto; }
        public String getCedente() { return cedente; }
        public String getCpfCnpjSacado() { return cpfCnpjSacado; }
        public String getNossoNumero() { return nossoNumero; }
        public String getValorLiquido() { return valorLiquido; }
    }
}