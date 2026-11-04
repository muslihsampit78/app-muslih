<?php

namespace App\Enums;

enum QuestionStatus: string
{
    case Pending = 'pending';
    case Answered = 'answered';
    case Rejected = 'rejected';

    public function label(): string
    {
        return match ($this) {
            self::Pending => 'Menunggu Jawaban',
            self::Answered => 'Sudah Dijawab',
            self::Rejected => 'Ditolak',
        };
    }

    public function color(): string
    {
        return match ($this) {
            self::Pending => 'warning',
            self::Answered => 'success',
            self::Rejected => 'danger',
        };
    }
}
