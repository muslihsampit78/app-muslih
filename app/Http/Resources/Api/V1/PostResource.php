<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class PostResource extends JsonResource
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
            'title' => $this->title,
            'slug' => $this->slug,
            'summary' => $this->summary,
            'content' => $this->content,
            'image_url' => $this->image ? Storage::disk('public')->url($this->image) : null,
            'status' => $this->status?->value ?? $this->status,
            'is_featured' => (bool) $this->is_featured,
            'view_count' => (int) $this->view_count,
            'published_at' => $this->published_at?->toIso8601String(),
            'created_at' => $this->created_at?->toIso8601String(),
            'category' => new CategoryResource($this->whenLoaded('category')),
            'author' => [
                'id' => $this->user?->id,
                'name' => $this->user?->name,
                'avatar_url' => $this->user?->avatar ? Storage::disk('public')->url($this->user->avatar) : null,
            ],
        ];
    }
}
