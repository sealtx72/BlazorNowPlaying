export default async (request, context) => {
    const key = Netlify.env.get('API_KEY');
    let tmdbUrl = Netlify.env.get('API_URL');

    if (!tmdbUrl.endsWith('/')) tmdbUrl += '/';

    const url = new URL(request.url);
    const tmdbPath = url.pathname.replace('/tmdb/', '');

    return await fetch(tmdbUrl + tmdbPath + url.search, {
        headers: {
            'Authorization': `Bearer ${key}`
        }
    });
};

export const config = {
    path: '/tmdb/*'
}