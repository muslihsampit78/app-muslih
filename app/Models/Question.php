<?php

namespace App\Models;

use App\Enums\QuestionStatus;
use Database\Factories\QuestionFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

#[Fillable([
    'topic_id',
    'name',
    'email',
    'phone',
    'subject',
    'body',
    'status',
    'ip_address',
])]
class Question extends Model
{
    /** @use HasFactory<QuestionFactory> */
    use HasFactory;

    protected function casts(): array
    {
        return [
            'status' => QuestionStatus::class,
        ];
    }

    public function topic(): BelongsTo
    {
        return $this->belongsTo(QuestionTopic::class, 'topic_id');
    }

    public function answers(): HasMany
    {
        return $this->hasMany(QuestionAnswer::class);
    }

    public function latestAnswer(): HasOne
    {
        return $this->hasOne(QuestionAnswer::class)->latestOfMany();
    }

    public function publishedAnswer(): HasOne
    {
        return $this->hasOne(QuestionAnswer::class)->where('is_published', true)->latestOfMany();
    }
}
