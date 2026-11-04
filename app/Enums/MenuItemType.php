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
            self::Page => __('Static Page'),
            self::Post => __('Article/Post'),
            self::Category => __('Category'),
            self::Custom => __('Custom Link (URL)'),
        };
    }
}
