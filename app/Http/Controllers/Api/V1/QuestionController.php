<?php

namespace App\Http\Controllers\Api\V1;

use App\Enums\QuestionStatus;
use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\QuestionResource;
use App\Models\Question;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class QuestionController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $query = Question::query()
            ->where('status', QuestionStatus::Answered->value)
            ->whereHas('publishedAnswer')
            ->with(['topic', 'publishedAnswer.user'])
            ->latest();

        if ($request->filled('topic')) {
            $query->whereHas('topic', function ($q) use ($request) {
                $q->where('slug', $request->query('topic'))
                    ->orWhere('id', $request->query('topic'));
            });
        }

        if ($request->filled('search')) {
            $search = '%'.$request->query('search').'%';
            $query->where(function ($q) use ($search) {
                $q->where('subject', 'like', $search)
                    ->orWhere('body', 'like', $search);
            });
        }

        $perPage = min((int) $request->query('per_page', 10), 30);

        return QuestionResource::collection($query->paginate($perPage));
    }

    public function show(int $id): QuestionResource
    {
        $question = Question::query()
            ->where('status', QuestionStatus::Answered->value)
            ->whereHas('publishedAnswer')
            ->with(['topic', 'publishedAnswer.user'])
            ->findOrFail($id);

        return new QuestionResource($question);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'topic_id' => ['nullable', 'exists:question_topics,id'],
            'name' => ['required', 'string', 'max:100'],
            'email' => ['required', 'email', 'max:150'],
            'phone' => ['nullable', 'string', 'max:30'],
            'subject' => ['required', 'string', 'max:200'],
            'body' => ['required', 'string', 'min:10', 'max:5000'],
        ]);

        $validated['status'] = QuestionStatus::Pending->value;
        $validated['ip_address'] = $request->ip();

        $question = Question::create($validated);

        return response()->json([
            'message' => 'Pertanyaan Anda berhasil dikirim dan sedang menunggu respon dari pihak kami.',
            'data' => [
                'id' => $question->id,
                'subject' => $question->subject,
                'status' => $question->status->value,
                'created_at' => $question->created_at->toIso8601String(),
            ],
        ], 201);
    }
}
