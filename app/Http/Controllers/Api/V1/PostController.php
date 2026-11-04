<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\PostResource;
use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class PostController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $query = Post::query()
            ->published()
            ->with(['category', 'user'])
            ->latest('published_at');

        if ($request->filled('category')) {
            $query->whereHas('category', function ($q) use ($request) {
                $q->where('slug', $request->query('category'))
                    ->orWhere('id', $request->query('category'));
            });
        }

        if ($request->boolean('featured')) {
            $query->featured();
        }

        if ($request->filled('search')) {
            $search = '%'.$request->query('search').'%';
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', $search)
                    ->orWhere('summary', 'like', $search)
                    ->orWhere('content', 'like', $search);
            });
        }

        $perPage = min((int) $request->query('per_page', 10), 50);

        return PostResource::collection($query->paginate($perPage));
    }

    public function show(string $slug): PostResource
    {
        $post = Post::query()
            ->published()
            ->with(['category', 'user'])
            ->where('slug', $slug)
            ->firstOrFail();

        $post->increment('view_count');

        return new PostResource($post);
    }
}
