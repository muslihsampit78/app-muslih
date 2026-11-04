<?php

namespace App\Enums;

enum UserRole: string
{
    case Admin = 'admin';
    case Editor = 'editor';
    case Viewer = 'viewer';

    public function label(): string
    {
        return match ($this) {
            self::Admin => __('Administrator'),
            self::Editor => __('Editor'),
            self::Viewer => __('Viewer'),
        };
    }
}
