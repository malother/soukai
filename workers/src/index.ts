/**
 * SoukAI backend stub — Cloudflare Worker (TypeScript).
 *
 * Endpoints:
 *   GET  /health    -> service status
 *   POST /generate  -> generate a sales listing from product data
 *
 * MOCK MODE: /generate currently returns a template-based listing.
 * The real Gemini call is wired in on PLAN.md days 7-9; the key will live
 * in a Worker secret (GEMINI_API_KEY), never in this file.
 */

export interface Env {
  GEMINI_API_KEY?: string;
  MOCK_MODE?: string;
}

interface GenerateRequest {
  name: string;
  category: string;
  condition: string;
  comparableMin?: number;
  comparableMax?: number;
}

interface ListingResponse {
  titleAr: string;
  titleFr: string;
  descriptionAr: string;
  descriptionFr: string;
  hashtags: string[];
  suggestedPrice: number;
  currency: string;
  mock: boolean;
}

const CONDITION_FACTOR: Record<string, number> = {
  brandNew: 1.0,
  likeNew: 0.85,
  good: 0.7,
  fair: 0.5,
};

function roundToNicePrice(price: number): number {
  if (price <= 0) return 0;
  const step = price < 1000 ? 50 : 100;
  return Math.round(price / step) * step;
}

function mockListing(body: GenerateRequest): ListingResponse {
  const factor = CONDITION_FACTOR[body.condition] ?? 0.7;
  const min = body.comparableMin ?? 0;
  const max = body.comparableMax ?? 0;
  const mid = (min + max) / 2;
  const suggested =
    min > 0 && max >= min ? roundToNicePrice(mid * factor) : 0;

  return {
    titleAr: `✨ ${body.name} ✨`,
    titleFr: `${body.name}`,
    descriptionAr: `${body.name} للبيع. للحجز أو الاستفسار راسلنا على واتساب.`,
    descriptionFr: `${body.name} à vendre. Pour commander, contactez-nous sur WhatsApp.`,
    hashtags: ['#تسوق_الجزائر', '#بيع_وشراء', '#soukai'],
    suggestedPrice: suggested,
    currency: 'DZD',
    mock: true,
  };
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    if (request.method === 'GET' && url.pathname === '/health') {
      return Response.json({
        ok: true,
        service: 'soukai-api',
        mock: env.MOCK_MODE !== 'false',
      });
    }

    if (request.method === 'POST' && url.pathname === '/generate') {
      let body: GenerateRequest;
      try {
        body = (await request.json()) as GenerateRequest;
      } catch {
        return Response.json(
          { error: 'Invalid JSON body' },
          { status: 400 },
        );
      }
      if (!body.name || !body.category || !body.condition) {
        return Response.json(
          { error: 'Missing required fields: name, category, condition' },
          { status: 400 },
        );
      }
      if (
        body.comparableMin !== undefined &&
        body.comparableMax !== undefined &&
        body.comparableMax < body.comparableMin
      ) {
        return Response.json(
          { error: 'comparableMax must be >= comparableMin' },
          { status: 400 },
        );
      }
      // TODO (PLAN.md days 7-9): if env.GEMINI_API_KEY is set, call Gemini
      // and return a real listing with mock: false.
      return Response.json(mockListing(body));
    }

    return Response.json({ error: 'Not found' }, { status: 404 });
  },
};
