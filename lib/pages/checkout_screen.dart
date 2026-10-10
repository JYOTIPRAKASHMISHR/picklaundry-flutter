import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const CheckoutScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  bool placingOrder = false;

  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();

    items = widget.order["items"] ?? [];

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //---------------------------------------------------
  // PLAN CHIP
  //---------------------------------------------------

  Widget planChip(String plan) {

    Color color = Colors.blue;

    switch (plan.toUpperCase()) {
      case "EXPRESS":
        color = Colors.orange;
        break;

      case "PREMIUM":
        color = Colors.purple;
        break;

      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        plan.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  //---------------------------------------------------
  // INFO CARD
  //---------------------------------------------------

  Widget infoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xff1E293B),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(.15),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //---------------------------------------------------
  // GENERATE PDF
  //---------------------------------------------------

  Future<void> generateInvoice() async {

    final pdf = pw.Document();

    pdf.addPage(

      pw.Page(

        pageFormat: PdfPageFormat.a4,

        build: (context) {

          return pw.Column(

            crossAxisAlignment:
                pw.CrossAxisAlignment.start,

            children: [

              pw.Text(
                "PickLaundry",
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 8),

              pw.Text(
                "Laundry Invoice",
                style: const pw.TextStyle(
                  fontSize: 20,
                ),
              ),

              pw.Divider(),

              pw.Text(
                  "Order ID : ${widget.order["orderId"]}"),

              pw.Text(
                  "Customer : ${widget.order["customerName"]}"),

              pw.Text(
                  "Mobile : ${widget.order["mobileNumber"]}"),

              pw.Text(
                  "Pickup Address : ${widget.order["pickupAddress"]}"),

              pw.Text(
                  "Payment : ${widget.order["paymentMethod"]}"),

              pw.Text(
                  "Plan : ${widget.order["selectedPlan"]}"),

              pw.SizedBox(height: 20),

              pw.Text(
                "Laundry Items",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),

                            for (var item in items)
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [

                      pw.Text(
                        item["serviceName"] ?? "",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),

                      pw.SizedBox(height: 4),

                      pw.Text(
                        item["itemName"] ?? "",
                      ),

                      pw.Text(
                        "Plan : ${item["selectedPlan"] ?? widget.order["selectedPlan"]}",
                      ),

                      pw.Text(
                        "Qty : ${item["quantity"]}",
                      ),

                      pw.Text(
                        "Price : ₹${item["price"]}",
                      ),

                      pw.Text(
                        "Subtotal : ₹${item["subtotal"]}",
                      ),
                    ],
                  ),
                ),

                pw.Divider(),

                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    "Grand Total : ₹${widget.order["grandTotal"]}",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 18,
                     ),
  ),
),

// <-- CLOSE THE CHILDREN LIST
],
);

// <-- CLOSE pw.Column
},

// <-- CLOSE build
),

// <-- CLOSE pw.Page
);


    // Request storage permission
await Permission.storage.request();

// Create PDF bytes
final pdfBytes = await pdf.save();

// Download folder
final directory = Directory("/storage/emulated/0/Download");

// Create folder if it doesn't exist
if (!directory.existsSync()) {
  directory.createSync(recursive: true);
}

// File name
final file = File(
  "${directory.path}/Invoice_${widget.order["orderId"]}.pdf",
);

// Save PDF
await file.writeAsBytes(pdfBytes);
await Printing.layoutPdf(
  onLayout: (format) async => pdfBytes,
);

// Show success message
if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "Invoice saved successfully!\n${file.path}",
      ),
      backgroundColor: Colors.green,
    ),
  );
}
  }

  //--------------------------------------------------
  // BUILD METHOD
  //--------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xff0F172A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Checkout",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ScaleTransition(

        scale: _animation,

        child: Column(

          children: [

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(20),

              child: const Column(

                children: [

                  Icon(
                     Icons.check_circle,
                     color: Colors.green,
                    size: 80,
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Order Placed Successfully",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Please verify all details before placing your order.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(

              child: Container(

                padding: const EdgeInsets.all(20),

                decoration: const BoxDecoration(

                  color: Color(0xff111827),

                  borderRadius: BorderRadius.only(

                    topLeft: Radius.circular(30),

                    topRight: Radius.circular(30),

                  ),
                ),

                child: ListView(

                  children: [

                    const Text(
                      "Customer Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    infoCard(
                      title: "Customer",
                      value: widget.order["customerName"] ?? "",
                      icon: Icons.person,
                      color: Colors.blue,
                    ),

                    infoCard(
                      title: "Mobile",
                      value: widget.order["mobileNumber"] ?? "",
                      icon: Icons.phone,
                      color: Colors.green,
                    ),

                    infoCard(
                      title: "Pickup Address",
                      value: widget.order["pickupAddress"] ?? "",
                      icon: Icons.location_on,
                      color: Colors.red,
                    ),

                    infoCard(
                      title: "Payment Method",
                      value: widget.order["paymentMethod"] ?? "Cash On Delivery",
                      icon: Icons.payments,
                      color: Colors.orange,
                    ),

                    infoCard(
                      title: "Order ID",
                      value: widget.order["orderId"] ?? "",
                      icon: Icons.receipt_long,
                      color: Colors.purple,
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "Laundry Items",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),
                    for (var item in items)
  Container(
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xff1E293B),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        //----------------------------------------
        // SERVICE NAME
        //----------------------------------------

        Text(
          item["serviceName"] ?? "",
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        //----------------------------------------
        // ITEM NAME
        //----------------------------------------

        Text(
          item["itemName"] ?? "",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        Row(
          children: [

            planChip(
              item["selectedPlan"] ??
                  widget.order["selectedPlan"] ??
                  "BASE",
            ),

            const Spacer(),

            Text(
              "Qty : ${item["quantity"]}",
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        Row(
          children: [

            const Icon(
              Icons.currency_rupee,
              color: Colors.green,
              size: 20,
            ),

            Text(
              "${item["price"]}",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(width: 10),

            const Text(
              "×",
              style: TextStyle(
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 10),

            Text(
              "${item["quantity"]}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),

            const Spacer(),

            Text(
              "Subtotal ₹${item["subtotal"]}",
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    ),
  ),

const SizedBox(height: 25),

//----------------------------------------
// GRAND TOTAL CARD
//----------------------------------------

Container(
  padding: const EdgeInsets.all(25),

  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xff2563EB),
        Color(0xff4F46E5),
      ],
    ),
    borderRadius: BorderRadius.circular(25),
  ),

  child: Column(
    children: [

      const Text(
        "Grand Total",
        style: TextStyle(
          color: Colors.white70,
          fontSize: 18,
        ),
      ),

      const SizedBox(height: 12),

      Text(
        "₹${widget.order["grandTotal"]}",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 12),

      Text(
        "Payment : ${widget.order["paymentMethod"]}",
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    ],
  ),
),

const SizedBox(height: 30),

SizedBox(
  width: double.infinity,
  height: 58,

  child: ElevatedButton.icon(

    icon: placingOrder
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
        : const Icon(Icons.check_circle),

    label: Text(
      placingOrder
          ? "Placing Order..."
          : "Place Order",
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),

    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),

    onPressed: placingOrder
        ? null
        : () async {

            setState(() {
              placingOrder = true;
            });

            await Future.delayed(
              const Duration(seconds: 2),
            );

            setState(() {
              placingOrder = false;
            });

            await generateInvoice();

            if (!mounted) return;

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => successDialog(),
            );
          },
  ),
),

const SizedBox(height: 30),
  ],
),
),
),
],
),
),
);
}

//------------------------------------------------------
// SUCCESS DIALOG
//------------------------------------------------------

Widget successDialog() {
  return AlertDialog(
    backgroundColor: const Color(0xff1E293B),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),

    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 90,
        ),

        const SizedBox(height: 20),

        const Text(
          "Order Placed Successfully",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        Text(
          "Order ID\n${widget.order["orderId"]}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          "Pickup partner will contact you shortly.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white54,
          ),
        ),

        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(

            icon: const Icon(Icons.picture_as_pdf),

            label: const Text(
              "Download Invoice",
            ),

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),

            onPressed: () async {

              Navigator.pop(context);

              await generateInvoice();

              if (!mounted) return;

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => successDialog(),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(

            icon: const Icon(Icons.home),

            label: const Text(
              "Back To Home",
            ),

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),

            onPressed: () {

              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            },
          ),
        ),
      ],
    ),
  );
}
}