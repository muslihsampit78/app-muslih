<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;
use Symfony\Component\HttpFoundation\Response;

class SetLocale
{
    /**
     * Daftar locale yang didukung aplikasi.
     *
     * @var array<string>
     */
    protected array $supportedLocales = ['id', 'en'];

    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next): Response
    {
        $locale = $this->determineLocale($request);

        if ($locale && in_array($locale, $this->supportedLocales, true)) {
            App::setLocale($locale);
        }

        return $next($request);
    }

    protected function determineLocale(Request $request): ?string
    {
        // 1. Prioritas query parameter (?lang=en atau ?locale=id)
        if ($request->filled('lang')) {
            $lang = strtolower((string) $request->query('lang'));
            if (in_array($lang, $this->supportedLocales, true)) {
                return $lang;
            }
        }

        if ($request->filled('locale')) {
            $locale = strtolower((string) $request->query('locale'));
            if (in_array($locale, $this->supportedLocales, true)) {
                return $locale;
            }
        }

        // 2. Cek session jika tersedia
        if ($request->hasSession() && $request->session()->has('locale')) {
            $sessionLocale = (string) $request->session()->get('locale');
            if (in_array($sessionLocale, $this->supportedLocales, true)) {
                return $sessionLocale;
            }
        }

        // 3. Header Accept-Language dari client (misal: Flutter / Browser)
        if ($request->header('Accept-Language')) {
            $preferred = $request->getPreferredLanguage($this->supportedLocales);
            if ($preferred && in_array($preferred, $this->supportedLocales, true)) {
                return $preferred;
            }
        }

        return config('app.locale', 'id');
    }
}
