<?php

namespace App\Enums;

enum MenuLocation: string
{
    case Header = 'header';
    case Footer = 'footer';
    case Sidebar = 'sidebar';

    public function label(): string
    {
        return match ($this) {
            self::Header => 'Header (Atas)',
            self::Footer => 'Footer (Bawah)',
            self::Sidebar => 'Sidebar (Samping)',
        };
    }
}

