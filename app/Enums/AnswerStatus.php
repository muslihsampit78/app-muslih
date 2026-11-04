<?php

namespace App\Enums;

enum AnswerStatus: string
{
    case Draft = 'draft';
    case Published = 'published';
    case Rejected = 'rejected';

    public function label(): string
    {
        return match ($this) {
            self::Draft => 'Draf',
            self::Published => 'Diterbitkan ke Publik',
            self::Rejected => 'Ditolak / Rahasia',
        };
    }

    public function color(): string
    {
        return match ($this) {
            self::Draft => 'gray',
            self::Published => 'success',
            self::Rejected => 'danger',
        };
    }
}

