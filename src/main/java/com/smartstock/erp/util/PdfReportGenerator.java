package com.smartstock.erp.util;

import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.*;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.smartstock.erp.model.Product;
import com.smartstock.erp.model.PurchaseOrder;
import com.smartstock.erp.model.PurchaseOrderItem;
import com.smartstock.erp.model.StockMovement;

import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Utilitaire de génération de rapports PDF pour SmartStockERP.
 *
 * <p>Utilise la bibliothèque iText 7 pour générer des rapports professionnels :</p>
 * <ul>
 *   <li>Rapport d'inventaire complet</li>
 *   <li>Rapport des alertes de stock (faible + rupture)</li>
 *   <li>Rapport des mouvements de stock</li>
 *   <li>Bon de commande fournisseur</li>
 * </ul>
 *
 * <p>Toutes les méthodes sont statiques et écrivent directement dans un {@link OutputStream}
 * pour permettre le streaming HTTP sans fichier temporaire.</p>
 */
public class PdfReportGenerator {

    // Palette de couleurs SmartStockERP
    private static final DeviceRgb COLOR_PRIMARY    = new DeviceRgb(11, 94, 158);   // Bleu principal
    private static final DeviceRgb COLOR_SECONDARY  = new DeviceRgb(15, 23, 42);    // Bleu foncé
    private static final DeviceRgb COLOR_SUCCESS    = new DeviceRgb(22, 163, 74);   // Vert
    private static final DeviceRgb COLOR_DANGER     = new DeviceRgb(220, 38, 38);   // Rouge
    private static final DeviceRgb COLOR_WARNING    = new DeviceRgb(234, 88, 12);   // Orange
    private static final DeviceRgb COLOR_LIGHT_BG   = new DeviceRgb(241, 245, 249); // Fond gris clair
    private static final DeviceRgb COLOR_HEADER_BG  = new DeviceRgb(30, 41, 59);    // Fond en-tête tableau

    private static final DateTimeFormatter DATETIME_FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final DateTimeFormatter DATE_FMT     = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    // =========================================================================
    // RAPPORT D'INVENTAIRE
    // =========================================================================

    /**
     * Génère un rapport d'inventaire complet au format PDF.
     *
     * @param products   liste de tous les produits
     * @param totalValue valeur totale du stock
     * @param out        flux de sortie (réponse HTTP ou fichier)
     */
    public static void generateInventoryReport(List<Product> products,
                                               BigDecimal totalValue,
                                               OutputStream out) throws IOException {
        try (PdfDocument pdf = new PdfDocument(new PdfWriter(out));
             Document doc = new Document(pdf, PageSize.A4)) {

            doc.setMargins(40, 40, 40, 40);
            PdfFont fontBold    = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);
            PdfFont fontRegular = PdfFontFactory.createFont(StandardFonts.HELVETICA);

            // En-tête du rapport
            addReportHeader(doc, fontBold, fontRegular, "RAPPORT D'INVENTAIRE",
                    "Liste complète des produits en stock");

            // Résumé
            addSummaryBox(doc, fontBold, fontRegular, new String[]{
                    "Nombre de produits", String.valueOf(products.size()),
                    "Valeur totale du stock", formatAmount(totalValue) + " DH",
                    "Date de génération", LocalDateTime.now().format(DATETIME_FMT)
            });

            // Tableau des produits
            Table table = createStyledTable(new float[]{2, 1.5f, 3, 1, 1, 1.5f, 1.5f});
            addTableHeader(table, fontBold, "Référence", "Code-barres", "Désignation",
                    "Qté stock", "Seuil alerte", "Prix unitaire", "Valeur stock");

            for (Product p : products) {
                boolean isLow    = p.getStockQuantity() <= p.getAlertThreshold() && p.getStockQuantity() > 0;
                boolean isOut    = p.getStockQuantity() == 0;
                DeviceRgb rowBg  = isOut ? new DeviceRgb(254, 226, 226)
                        : isLow ? new DeviceRgb(255, 237, 213) : null;

                BigDecimal stockValue = p.getUnitPrice() != null
                        ? p.getUnitPrice().multiply(BigDecimal.valueOf(p.getStockQuantity()))
                        : BigDecimal.ZERO;

                addTableRow(table, fontRegular, rowBg,
                        p.getId() != null ? String.valueOf(p.getId()) : "—",
                        "—",
                        p.getLabel(),
                        String.valueOf(p.getStockQuantity()),
                        String.valueOf(p.getAlertThreshold()),
                        formatAmount(p.getUnitPrice()) + " DH",
                        formatAmount(stockValue) + " DH");
            }

            doc.add(table);

            // Pied de page
            addFooter(doc, fontRegular);
        }
    }

    // =========================================================================
    // RAPPORT ALERTES DE STOCK
    // =========================================================================

    /**
     * Génère un rapport des produits en stock faible ou en rupture.
     */
    public static void generateLowStockReport(List<Product> lowStock,
                                              List<Product> outOfStock,
                                              OutputStream out) throws IOException {
        try (PdfDocument pdf = new PdfDocument(new PdfWriter(out));
             Document doc = new Document(pdf, PageSize.A4)) {

            doc.setMargins(40, 40, 40, 40);
            PdfFont fontBold    = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);
            PdfFont fontRegular = PdfFontFactory.createFont(StandardFonts.HELVETICA);

            addReportHeader(doc, fontBold, fontRegular, "RAPPORT D'ALERTES DE STOCK",
                    "Produits nécessitant un réapprovisionnement");

            addSummaryBox(doc, fontBold, fontRegular, new String[]{
                    "Ruptures de stock", String.valueOf(outOfStock.size()),
                    "Stock faible", String.valueOf(lowStock.size()),
                    "Total alertes", String.valueOf(outOfStock.size() + lowStock.size())
            });

            // Section ruptures
            if (!outOfStock.isEmpty()) {
                doc.add(new Paragraph("RUPTURES DE STOCK")
                        .setFont(fontBold).setFontSize(11).setFontColor(COLOR_DANGER)
                        .setMarginTop(16).setMarginBottom(8));

                Table t = createStyledTable(new float[]{2, 3, 1, 1.5f});
                addTableHeader(t, fontBold, "Référence", "Désignation", "Stock", "Fournisseur");
                for (Product p : outOfStock) {
                    addTableRow(t, fontRegular, new DeviceRgb(254, 226, 226),
                            p.getId() != null ? String.valueOf(p.getId()) : "—",
                            p.getLabel(),
                            "0",
                            p.getSupplier() != null ? p.getSupplier().getName() : "—");
                }
                doc.add(t);
            }

            // Section stock faible
            if (!lowStock.isEmpty()) {
                doc.add(new Paragraph("STOCK FAIBLE")
                        .setFont(fontBold).setFontSize(11).setFontColor(COLOR_WARNING)
                        .setMarginTop(20).setMarginBottom(8));

                Table t = createStyledTable(new float[]{2, 3, 1, 1, 1.5f});
                addTableHeader(t, fontBold, "Référence", "Désignation", "Stock", "Seuil", "Fournisseur");
                for (Product p : lowStock) {
                    addTableRow(t, fontRegular, new DeviceRgb(255, 237, 213),
                            p.getId() != null ? String.valueOf(p.getId()) : "—",
                            p.getLabel(),
                            String.valueOf(p.getStockQuantity()),
                            String.valueOf(p.getAlertThreshold()),
                            p.getSupplier() != null ? p.getSupplier().getName() : "—");
                }
                doc.add(t);
            }

            addFooter(doc, fontRegular);
        }
    }

    // =========================================================================
    // RAPPORT MOUVEMENTS DE STOCK
    // =========================================================================

    /**
     * Génère un rapport des mouvements de stock récents.
     */
    public static void generateMovementsReport(List<StockMovement> movements,
                                               OutputStream out) throws IOException {
        try (PdfDocument pdf = new PdfDocument(new PdfWriter(out));
             Document doc = new Document(pdf, PageSize.A4.rotate())) {

            doc.setMargins(40, 40, 40, 40);
            PdfFont fontBold    = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);
            PdfFont fontRegular = PdfFontFactory.createFont(StandardFonts.HELVETICA);

            addReportHeader(doc, fontBold, fontRegular, "RAPPORT DES MOUVEMENTS DE STOCK",
                    movements.size() + " mouvement(s) enregistré(s)");

            Table table = createStyledTable(new float[]{2, 1.5f, 1, 1, 1, 2, 2, 2});
            addTableHeader(table, fontBold, "Produit", "Type", "Quantité",
                    "Avant", "Après", "Date", "Référence", "Opérateur");

            for (StockMovement mv : movements) {
                boolean isEntry = "ENTRY".equals(mv.getMovementType());
                boolean isExit  = "EXIT".equals(mv.getMovementType());
                DeviceRgb qtyColor = isEntry ? COLOR_SUCCESS : isExit ? COLOR_DANGER : null;

                Cell qtyCell = new Cell()
                        .add(new Paragraph((isEntry ? "+" : isExit ? "-" : "") + mv.getQuantity())
                                .setFont(fontBold).setFontSize(9)
                                .setFontColor(qtyColor != null ? qtyColor : ColorConstants.BLACK))
                        .setTextAlignment(TextAlignment.CENTER)
                        .setPadding(4);

                String typeLabel = isEntry ? "Entrée" : isExit ? "Sortie" : "Ajustement";
                DeviceRgb typeBg = isEntry ? new DeviceRgb(220, 252, 231)
                        : isExit ? new DeviceRgb(254, 226, 226)
                        : new DeviceRgb(226, 232, 240);

                Cell typeCell = new Cell()
                        .add(new Paragraph(typeLabel).setFont(fontBold).setFontSize(8)
                                .setFontColor(isEntry ? COLOR_SUCCESS : isExit ? COLOR_DANGER : ColorConstants.DARK_GRAY))
                        .setBackgroundColor(typeBg)
                        .setTextAlignment(TextAlignment.CENTER)
                        .setPadding(4);

                String dateStr = mv.getMovementDate() != null
                        ? mv.getMovementDate().format(DATETIME_FMT) : "—";

                table.addCell(createCell(mv.getProduct().getLabel(), fontRegular));
                table.addCell(typeCell);
                table.addCell(qtyCell);
                table.addCell(createCell(String.valueOf(mv.getQuantityBefore()), fontRegular));
                table.addCell(createCell(String.valueOf(mv.getQuantityAfter()), fontRegular));
                table.addCell(createCell(dateStr, fontRegular));
                table.addCell(createCell(mv.getReference() != null ? mv.getReference() : "—", fontRegular));
                table.addCell(createCell(mv.getPerformedBy() != null ? mv.getPerformedBy().getFullName() : "Système", fontRegular));
            }

            doc.add(table);
            addFooter(doc, fontRegular);
        }
    }

    // =========================================================================
    // BON DE COMMANDE
    // =========================================================================

    /**
     * Génère un bon de commande fournisseur au format PDF.
     */
    public static void generatePurchaseOrderReport(PurchaseOrder order,
                                                   OutputStream out) throws IOException {
        try (PdfDocument pdf = new PdfDocument(new PdfWriter(out));
             Document doc = new Document(pdf, PageSize.A4)) {

            doc.setMargins(40, 40, 40, 40);
            PdfFont fontBold    = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);
            PdfFont fontRegular = PdfFontFactory.createFont(StandardFonts.HELVETICA);

            // En-tête avec logo et titre
            Table headerTable = new Table(UnitValue.createPercentArray(new float[]{1, 1})).useAllAvailableWidth();

            Cell companyCell = new Cell()
                    .add(new Paragraph("SmartStockERP").setFont(fontBold).setFontSize(18).setFontColor(COLOR_PRIMARY))
                    .add(new Paragraph("Système de Gestion de Stock").setFont(fontRegular).setFontSize(9).setFontColor(ColorConstants.GRAY))
                    .setBorder(null).setPaddingBottom(8);

            Cell titleCell = new Cell()
                    .add(new Paragraph("BON DE COMMANDE").setFont(fontBold).setFontSize(14)
                            .setFontColor(COLOR_SECONDARY).setTextAlignment(TextAlignment.RIGHT))
                    .add(new Paragraph("N° " + order.getOrderNumber()).setFont(fontBold).setFontSize(12)
                            .setFontColor(COLOR_PRIMARY).setTextAlignment(TextAlignment.RIGHT))
                    .setBorder(null).setPaddingBottom(8);

            headerTable.addCell(companyCell);
            headerTable.addCell(titleCell);
            doc.add(headerTable);

            // Ligne de séparation
            doc.add(new LineSeparator(new com.itextpdf.kernel.pdf.canvas.draw.SolidLine(1.5f))
                    .setStrokeColor(COLOR_PRIMARY).setMarginBottom(16));

            // Bloc fournisseur + infos commande
            Table infoTable = new Table(UnitValue.createPercentArray(new float[]{1, 1})).useAllAvailableWidth();

            Cell supplierCell = new Cell()
                    .add(new Paragraph("FOURNISSEUR").setFont(fontBold).setFontSize(8)
                            .setFontColor(ColorConstants.GRAY).setMarginBottom(4))
                    .add(new Paragraph(order.getSupplier().getName()).setFont(fontBold).setFontSize(11))
                    .add(new Paragraph(order.getSupplier().getEmail() != null ? order.getSupplier().getEmail() : "")
                            .setFont(fontRegular).setFontSize(9).setFontColor(ColorConstants.GRAY))
                    .setBorder(null).setBackgroundColor(COLOR_LIGHT_BG).setPadding(12).setBorderRadius(
                            new com.itextpdf.layout.properties.BorderRadius(8));

            Cell orderInfoCell = new Cell()
                    .add(new Paragraph("INFORMATIONS COMMANDE").setFont(fontBold).setFontSize(8)
                            .setFontColor(ColorConstants.GRAY).setMarginBottom(4))
                    .add(new Paragraph("Date : " + (order.getOrderDate() != null ? order.getOrderDate().format(DATE_FMT) : "—"))
                            .setFont(fontRegular).setFontSize(9))
                    .add(new Paragraph("Livraison prévue : " + (order.getExpectedDeliveryDate() != null
                            ? order.getExpectedDeliveryDate().format(DATE_FMT) : "—"))
                            .setFont(fontRegular).setFontSize(9))
                    .add(new Paragraph("Statut : " + translateStatus(order.getStatus().name()))
                            .setFont(fontBold).setFontSize(9))
                    .setBorder(null).setBackgroundColor(COLOR_LIGHT_BG).setPadding(12)
                    .setBorderRadius(new com.itextpdf.layout.properties.BorderRadius(8))
                    .setMarginLeft(8);

            infoTable.addCell(supplierCell);
            infoTable.addCell(orderInfoCell);
            doc.add(infoTable);
            doc.add(new Paragraph("").setMarginTop(16));

            // Tableau des lignes de commande
            Table itemsTable = createStyledTable(new float[]{0.8f, 3, 1, 1.5f, 1.5f});
            addTableHeader(itemsTable, fontBold, "Réf.", "Désignation", "Qté", "Prix unitaire HT", "Sous-total HT");

            BigDecimal totalHT = BigDecimal.ZERO;
            int lineNum = 1;
            for (PurchaseOrderItem item : order.getItems()) {
                BigDecimal subtotal = item.getUnitPrice().multiply(BigDecimal.valueOf(item.getQuantityOrdered()));
                totalHT = totalHT.add(subtotal);

                addTableRow(itemsTable, fontRegular, null,
                        String.valueOf(lineNum++),
                        item.getProduct().getLabel(),
                        String.valueOf(item.getQuantityOrdered()),
                        formatAmount(item.getUnitPrice()) + " DH",
                        formatAmount(subtotal) + " DH");
            }
            doc.add(itemsTable);

            // Totaux
            BigDecimal tva  = totalHT.multiply(order.getTaxRate()).divide(BigDecimal.valueOf(100));
            BigDecimal ttc  = totalHT.add(tva);

            Table totalsTable = new Table(UnitValue.createPercentArray(new float[]{3, 1})).useAllAvailableWidth();
            totalsTable.setMarginTop(8);

            addTotalRow(totalsTable, fontRegular, fontBold, "Total HT",  formatAmount(totalHT) + " DH", false);
            addTotalRow(totalsTable, fontRegular, fontBold, "TVA (" + order.getTaxRate() + "%)", formatAmount(tva) + " DH", false);
            addTotalRow(totalsTable, fontRegular, fontBold, "TOTAL TTC", formatAmount(ttc) + " DH", true);
            doc.add(totalsTable);

            // Notes
            if (order.getNotes() != null && !order.getNotes().isEmpty()) {
                doc.add(new Paragraph("Notes : " + order.getNotes())
                        .setFont(fontRegular).setFontSize(9).setFontColor(ColorConstants.GRAY)
                        .setMarginTop(16).setItalic());
            }

            // Signatures
            doc.add(new Paragraph("").setMarginTop(40));
            Table sigTable = new Table(UnitValue.createPercentArray(new float[]{1, 1})).useAllAvailableWidth();
            sigTable.addCell(new Cell().add(new Paragraph("Signature Acheteur").setFont(fontBold).setFontSize(9))
                    .add(new Paragraph("\n\n\n_____________________").setFont(fontRegular).setFontSize(9))
                    .setBorder(null).setTextAlignment(TextAlignment.CENTER));
            sigTable.addCell(new Cell().add(new Paragraph("Signature Fournisseur").setFont(fontBold).setFontSize(9))
                    .add(new Paragraph("\n\n\n_____________________").setFont(fontRegular).setFontSize(9))
                    .setBorder(null).setTextAlignment(TextAlignment.CENTER));
            doc.add(sigTable);

            addFooter(doc, fontRegular);
        }
    }

    // =========================================================================
    // MÉTHODES UTILITAIRES PRIVÉES
    // =========================================================================

    private static void addReportHeader(Document doc, PdfFont fontBold, PdfFont fontRegular,
                                        String title, String subtitle) throws IOException {
        // Bande de titre
        Table headerBand = new Table(UnitValue.createPercentArray(new float[]{3, 1})).useAllAvailableWidth();
        headerBand.addCell(new Cell()
                .add(new Paragraph("SmartStockERP").setFont(fontBold).setFontSize(10)
                        .setFontColor(ColorConstants.WHITE).setMarginBottom(2))
                .add(new Paragraph(title).setFont(fontBold).setFontSize(16)
                        .setFontColor(ColorConstants.WHITE))
                .add(new Paragraph(subtitle).setFont(fontRegular).setFontSize(9)
                        .setFontColor(new DeviceRgb(148, 163, 184)))
                .setBackgroundColor(COLOR_SECONDARY).setBorder(null).setPadding(16));

        headerBand.addCell(new Cell()
                .add(new Paragraph("Généré le\n" + LocalDateTime.now().format(DATETIME_FMT))
                        .setFont(fontRegular).setFontSize(9).setFontColor(ColorConstants.WHITE)
                        .setTextAlignment(TextAlignment.RIGHT))
                .setBackgroundColor(COLOR_SECONDARY).setBorder(null).setPadding(16)
                .setVerticalAlignment(com.itextpdf.layout.properties.VerticalAlignment.MIDDLE));

        doc.add(headerBand);
        doc.add(new Paragraph("").setMarginTop(16));
    }

    private static void addSummaryBox(Document doc, PdfFont fontBold, PdfFont fontRegular,
                                      String[] pairs) throws IOException {
        Table t = new Table(UnitValue.createPercentArray(new float[]{1, 1, 1})).useAllAvailableWidth();
        for (int i = 0; i < pairs.length; i += 2) {
            t.addCell(new Cell()
                    .add(new Paragraph(pairs[i]).setFont(fontRegular).setFontSize(8)
                            .setFontColor(ColorConstants.GRAY).setMarginBottom(2))
                    .add(new Paragraph(pairs[i + 1]).setFont(fontBold).setFontSize(13)
                            .setFontColor(COLOR_PRIMARY))
                    .setBackgroundColor(COLOR_LIGHT_BG).setBorder(null).setPadding(12)
                    .setBorderRadius(new com.itextpdf.layout.properties.BorderRadius(6)));
        }
        doc.add(t);
        doc.add(new Paragraph("").setMarginTop(16));
    }

    private static Table createStyledTable(float[] widths) {
        return new Table(UnitValue.createPercentArray(widths))
                .useAllAvailableWidth()
                .setMarginTop(4);
    }

    private static void addTableHeader(Table table, PdfFont fontBold, String... headers) {
        for (String header : headers) {
            table.addHeaderCell(new Cell()
                    .add(new Paragraph(header).setFont(fontBold).setFontSize(8)
                            .setFontColor(ColorConstants.WHITE))
                    .setBackgroundColor(COLOR_HEADER_BG)
                    .setPadding(8).setTextAlignment(TextAlignment.CENTER));
        }
    }

    private static void addTableRow(Table table, PdfFont font, DeviceRgb bgColor, String... values) {
        for (String value : values) {
            Cell cell = new Cell()
                    .add(new Paragraph(value != null ? value : "—").setFont(font).setFontSize(9))
                    .setPadding(6).setTextAlignment(TextAlignment.CENTER);
            if (bgColor != null) cell.setBackgroundColor(bgColor);
            table.addCell(cell);
        }
    }

    private static Cell createCell(String text, PdfFont font) {
        return new Cell()
                .add(new Paragraph(text != null ? text : "—").setFont(font).setFontSize(9))
                .setPadding(6).setTextAlignment(TextAlignment.CENTER);
    }

    private static void addTotalRow(Table table, PdfFont fontRegular, PdfFont fontBold,
                                    String label, String value, boolean highlight) {
        Cell labelCell = new Cell()
                .add(new Paragraph(label).setFont(highlight ? fontBold : fontRegular).setFontSize(10))
                .setBorder(null).setTextAlignment(TextAlignment.RIGHT).setPaddingRight(12).setPaddingTop(4);
        Cell valueCell = new Cell()
                .add(new Paragraph(value).setFont(fontBold).setFontSize(highlight ? 12 : 10)
                        .setFontColor(highlight ? COLOR_PRIMARY : ColorConstants.BLACK))
                .setBorder(null).setTextAlignment(TextAlignment.RIGHT).setPaddingTop(4);
        if (highlight) {
            labelCell.setBackgroundColor(COLOR_LIGHT_BG).setPadding(8);
            valueCell.setBackgroundColor(COLOR_LIGHT_BG).setPadding(8);
        }
        table.addCell(labelCell);
        table.addCell(valueCell);
    }

    private static void addFooter(Document doc, PdfFont fontRegular) throws IOException {
        doc.add(new Paragraph("").setMarginTop(24));
        doc.add(new LineSeparator(new com.itextpdf.kernel.pdf.canvas.draw.DashedLine(0.5f))
                .setStrokeColor(ColorConstants.LIGHT_GRAY));
        doc.add(new Paragraph("SmartStockERP — Système de Gestion de Stock | Document généré automatiquement le "
                + LocalDateTime.now().format(DATETIME_FMT))
                .setFont(fontRegular).setFontSize(8).setFontColor(ColorConstants.GRAY)
                .setTextAlignment(TextAlignment.CENTER).setMarginTop(4));
    }

    private static String formatAmount(BigDecimal amount) {
        if (amount == null) return "0,00";
        return String.format("%,.2f", amount).replace(",", " ").replace(".", ",");
    }

    private static String translateStatus(String status) {
        return switch (status) {
            case "DRAFT"              -> "Brouillon";
            case "SENT"               -> "Envoyé";
            case "PARTIALLY_RECEIVED" -> "Partiellement reçu";
            case "RECEIVED"           -> "Reçu";
            case "CANCELLED"          -> "Annulé";
            default -> status;
        };
    }
}
