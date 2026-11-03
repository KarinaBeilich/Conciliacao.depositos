package com.fidc.conciliacao;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

@Controller
public class ConciliacaoController {

    public static class DepositoDto {
        private String penData;
        private String cedente;
        private String cnpjCpf;
        private String penCodigo;
        private BigDecimal penValorOriginal;
        private BigDecimal total;
        private BigDecimal vencidos;
        private BigDecimal fomento;
        private BigDecimal comissaria;
        private String documento;
        private String ticket;
        private String status;
        private String obs;

        public DepositoDto(String penData, String cedente, String cnpjCpf, String penCodigo, 
                           BigDecimal penValorOriginal, BigDecimal total, BigDecimal vencidos, 
                           BigDecimal fomento, BigDecimal comissaria, String documento, String ticket, String status, String obs) {
            this.penData = penData;
            this.cedente = cedente;
            this.cnpjCpf = cnpjCpf;
            this.penCodigo = penCodigo;
            this.penValorOriginal = penValorOriginal;
            this.total = total;
            this.vencidos = vencidos;
            this.fomento = fomento;
            this.comissaria = comissaria;
            this.documento = documento;
            this.ticket = ticket;
            this.status = status;
            this.obs = obs;
        }

        // Getters
        public String getPenData() { return penData; }
        public String getCedente() { return cedente; }
        public String getCnpjCpf() { return cnpjCpf; }
        public String getPenCodigo() { return penCodigo; }
        public BigDecimal getPenValorOriginal() { return penValorOriginal; }
        public BigDecimal getTotal() { return total; }
        public BigDecimal getVencidos() { return vencidos; }
        public BigDecimal getFomento() { return fomento; }
        public BigDecimal getComissaria() { return comissaria; }
        public String getDocumento() { return documento; }
        public String getTicket() { return ticket; }
        public String getStatus() { return status; }
        public String getObs() { return obs; }
    }

    @GetMapping("/conciliacao")
    public String abrirTelaConciliacao(Model model) {
        // Dados fictícios baseados na sua planilha para testes visuais
        List<DepositoDto> listaMock = Arrays.asList(
            new DepositoDto("28/10/2026", "EMPRESA EXEMPLO ALFA LTDA", "00.000.000/0001-01", "1000001",
                            new BigDecimal("25000.00"), new BigDecimal("25000.00"), BigDecimal.ZERO,
                            new BigDecimal("25000.00"), BigDecimal.ZERO, "", "Não Localizado", "Analisar", "(Detalhar)"),
            new DepositoDto("29/10/2026", "EMPRESA EXEMPLO BETA LTDA", "00.000.000/0001-02", "1000002",
                            new BigDecimal("1200000.00"), new BigDecimal("1200000.00"), new BigDecimal("1200000.00"),
                            new BigDecimal("1200000.00"), BigDecimal.ZERO, "", "REQ-000001", "Pendente", "Falta credito para seguir com a liquidação : R$2.500,00 - REQ-000001"),
            new DepositoDto("29/10/2026", "EMPRESA EXEMPLO GAMA LTDA", "00.000.000/0001-03", "1000003",
                            new BigDecimal("500000.00"), new BigDecimal("825000.00"), BigDecimal.ZERO,
                            new BigDecimal("825000.00"), new BigDecimal("825000.00"), "", "Não Localizado", "Analisar", "(Detalhar)"),
            new DepositoDto("29/10/2026", "EMPRESA EXEMPLO DELTA LTDA", "00.000.000/0001-04", "1000004",
                            new BigDecimal("150.00"), new BigDecimal("1200000.00"), BigDecimal.ZERO,
                            BigDecimal.ZERO, BigDecimal.ZERO, "000001/001", "Não Localizado", "liquidado", ""),
            new DepositoDto("30/10/2026", "EMPRESA EXEMPLO EPSILON LTDA", "00.000.000/0001-05", "1000005",
                            new BigDecimal("25000.00"), new BigDecimal("25000.00"), BigDecimal.ZERO,
                            BigDecimal.ZERO, BigDecimal.ZERO, "000004/003", "Não Localizado", "Liquidar", "")
        );

        model.addAttribute("conciliacoes", listaMock);
        return "conciliacao";
    }
    
}