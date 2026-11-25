/**
 * 유튜브 쇼츠 자동생성기 (ShortsMaker) 전용 초경량 서버리스 TTS 중계 Worker
 * 배포 방법: Cloudflare Workers (무료) 대시보드에서 새 Worker 생성 후 아래 코드를 붙여넣고 배포하세요.
 */
export default {
  async fetch(request) {
    // CORS Preflight 처리
    if (request.method === "OPTIONS") {
      return new Response(null, {
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET, OPTIONS",
          "Access-Control-Allow-Headers": "Content-Type",
        },
      });
    }

    const url = new URL(request.url);
    const text = (url.searchParams.get("text") || "").trim();
    const lang = url.searchParams.get("lang") || "ko";

    if (!text) {
      return new Response("Missing text parameter", {
        status: 400,
        headers: { "Access-Control-Allow-Origin": "*" },
      });
    }

    // Google TTS 엔드포인트 호출 후 CORS 헤더와 함께 MP3 바이너리 반환
    const ttsUrl = `https://translate.google.com/translate_tts?ie=UTF-8&tl=${encodeURIComponent(lang)}&client=tw-ob&q=${encodeURIComponent(text)}`;
    const upstream = await fetch(ttsUrl, {
      headers: {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
      },
    });

    if (!upstream.ok) {
      return new Response("TTS Upstream Error", {
        status: upstream.status,
        headers: { "Access-Control-Allow-Origin": "*" },
      });
    }

    const audioBuffer = await upstream.arrayBuffer();
    return new Response(audioBuffer, {
      status: 200,
      headers: {
        "Content-Type": "audio/mpeg",
        "Access-Control-Allow-Origin": "*",
        "Cache-Control": "public, max-age=86400",
      },
    });
  },
};
