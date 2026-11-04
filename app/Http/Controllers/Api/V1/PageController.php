<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\PageResource;
use App\Models\Page;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class PageController extends Controller
{
    public function index(): AnonymousResourceCollection
    {
        $pages = Page::query()
            ->published()
            ->orderBy('sort_order')
            ->get();

        return PageResource::collection($pages);
    }

    public function show(string $slug): PageResource
    {
        $page = Page::query()
            ->published()
            ->where('slug', $slug)
            ->firstOrFail();

        return new PageResource($page);
    }
}
