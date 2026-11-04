<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MenuItemResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'label' => $this->label,
            'type' => $this->type?->value ?? $this->type,
            'url' => $this->url,
            'sort_order' => $this->sort_order,
            'children' => MenuItemResource::collection($this->whenLoaded('children')),
        ];
    }
}
