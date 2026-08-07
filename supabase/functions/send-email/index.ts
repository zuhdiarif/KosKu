import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { to, subject, body, tenantName, month, amount, ownerName } = await req.json();

    const resendApiKey = Deno.env.get("RESEND_API_KEY");
    if (!resendApiKey) {
      return new Response(
        JSON.stringify({ message: "Resend API key not configured, using client fallback" }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 400 }
      );
    }

    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${resendApiKey}`,
      },
      body: JSON.stringify({
        from: "Kosmo Management <notifikasi@kosmo.id>",
        to: [to],
        subject: subject || `Pengingat Pembayaran Kos - ${month}`,
        html: `
          <div style="font-family: Arial, sans-serif; padding: 20px; color: #191C1D;">
            <h2 style="color: #004532;">Pengingat Pembayaran Kos</h2>
            <p>Halo <strong>${tenantName}</strong>,</p>
            <p>Ini adalah pengingat pembayaran sewa kos untuk bulan <strong>${month}</strong> sebesar <strong>Rp ${amount}</strong>.</p>
            <p>Mohon segera melakukan pembayaran dan mengunggah bukti bayar melalui aplikasi Kosmo.</p>
            <br/>
            <p>Terima kasih,<br/><strong>${ownerName || "Manajemen Kos"}</strong></p>
          </div>
        `,
      }),
    });

    const data = await res.json();
    return new Response(JSON.stringify(data), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 200,
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 500,
    });
  }
});
