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
            self::Pending => __('Pending'),
            self::Answered => __('Answered'),
            self::Rejected => __('Rejected'),
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
