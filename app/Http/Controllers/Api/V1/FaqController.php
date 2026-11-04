<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\FaqResource;
use App\Models\Faq;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class FaqController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $query = Faq::query()
            ->where('is_active', true)
            ->with('topic')
            ->orderBy('sort_order');

        if ($request->filled('topic')) {
            $query->whereHas('topic', function ($q) use ($request) {
                $q->where('slug', $request->query('topic'))
                    ->orWhere('id', $request->query('topic'));
            });
        }

        if ($request->filled('search')) {
            $search = '%'.$request->query('search').'%';
            $query->where(function ($q) use ($search) {
                $q->where('question', 'like', $search)
                    ->orWhere('answer', 'like', $search);
            });
        }

        return FaqResource::collection($query->get());
    }
}
