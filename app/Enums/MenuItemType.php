<?php

namespace App\Enums;

enum MenuItemType: string
{
    case Page = 'page';
    case Post = 'post';
    case Category = 'category';
    case Custom = 'custom';

    public function label(): string
    {
        return match ($this) {
            self::Page => 'Halaman Statis',
            self::Post => 'Artikel/Post',
            self::Category => 'Kategori',
            self::Custom => 'Tautan Kustom (URL)',
        };
    }
}
