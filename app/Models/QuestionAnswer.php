<?php

namespace App\Models;

use App\Enums\AnswerStatus;
use Database\Factories\QuestionAnswerFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable([
    'question_id',
    'user_id',
    'body',
    'status',
    'is_published',
    'answered_at',
])]
class QuestionAnswer extends Model
{
    /** @use HasFactory<QuestionAnswerFactory> */
    use HasFactory;

    protected function casts(): array
    {
        return [
            'status' => AnswerStatus::class,
            'is_published' => 'boolean',
            'answered_at' => 'datetime',
        ];
    }

    public function question(): BelongsTo
    {
        return $this->belongsTo(Question::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
