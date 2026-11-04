<?php

namespace App\Models;

use Database\Factories\SettingFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

#[Fillable(['group', 'key', 'name', 'value', 'type', 'description'])]
class Setting extends Model
{
    /** @use HasFactory<SettingFactory> */
    use HasFactory;

    public static function get(string $key, mixed $default = null): mixed
    {
        $setting = static::query()->where('key', $key)->first();

        if (! $setting) {
            return $default;
        }

        return match ($setting->type) {
            'boolean' => filter_var($setting->value, FILTER_VALIDATE_BOOLEAN),
            'json' => json_decode((string) $setting->value, true) ?? $default,
            default => $setting->value ?? $default,
        };
    }

    public static function set(string $key, mixed $value, string $group = 'general', string $type = 'text'): void
    {
        $formattedValue = is_array($value) ? json_encode($value) : (string) $value;

        static::query()->updateOrCreate(
            ['key' => $key],
            [
                'group' => $group,
                'value' => $formattedValue,
                'type' => $type,
            ]
        );
    }
}
