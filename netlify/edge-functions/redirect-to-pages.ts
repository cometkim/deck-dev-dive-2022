import type { Context } from 'https://edge.netlify.com';

export default (request: Request, context: Context) => {
  const url = new URL(request.url);
  url.hostname = 'type-driven-development.pages.dev';

  return Response.redirect(url, 301);
};