<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class SettingResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $value = $this->value;

        if ($this->type === 'image' && $value) {
            $value = Storage::disk('public')->url($value);
        } elseif ($this->type === 'boolean') {
            $value = filter_var($value, FILTER_VALIDATE_BOOLEAN);
        } elseif ($this->type === 'json' && $value) {
            $value = json_decode((string) $value, true);
        }

        return [
            'group' => $this->group,
            'key' => $this->key,
            'name' => $this->name,
            'value' => $value,
            'type' => $this->type,
        ];
    }
}
