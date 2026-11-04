<?php

namespace Tests\Feature;

use App\Models\Page;
use App\Models\Post;
use App\Models\QuestionTopic;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ApiV1Test extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed();
    }

    public function test_can_fetch_categories_list(): void
    {
        $response = $this->getJson('/api/v1/categories');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'name', 'slug', 'description', 'icon', 'sort_order'],
                ],
            ]);
    }

    public function test_can_fetch_posts_list_and_detail(): void
    {
        $response = $this->getJson('/api/v1/posts');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'title', 'slug', 'summary', 'image_url', 'view_count'],
                ],
            ]);

        $post = Post::published()->first();
        $this->assertNotNull($post);

        $initialViews = $post->view_count;

        $detailResponse = $this->getJson('/api/v1/posts/'.$post->slug);
        $detailResponse->assertOk()
            ->assertJsonPath('data.title', $post->title);

        $this->assertEquals($initialViews + 1, $post->fresh()->view_count);
    }

    public function test_can_fetch_page_detail(): void
    {
        $page = Page::published()->first();
        $this->assertNotNull($page);

        $response = $this->getJson('/api/v1/pages/'.$page->slug);
        $response->assertOk()
            ->assertJsonPath('data.title', $page->title);
    }

    public function test_can_fetch_slides(): void
    {
        $response = $this->getJson('/api/v1/slides');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'title', 'image_url', 'link_url'],
                ],
            ]);
    }

    public function test_can_fetch_menu_by_location(): void
    {
        $response = $this->getJson('/api/v1/menus/header');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => ['id', 'name', 'location', 'items'],
            ]);
    }

    public function test_can_fetch_settings(): void
    {
        $response = $this->getJson('/api/v1/settings');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    '*' => ['group', 'key', 'name', 'value', 'type'],
                ],
                'meta' => ['values'],
            ]);
    }

    public function test_can_fetch_question_topics(): void
    {
        $response = $this->getJson('/api/v1/question-topics');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'name', 'slug', 'description'],
                ],
            ]);
    }

    public function test_can_fetch_public_answered_questions(): void
    {
        $response = $this->getJson('/api/v1/questions');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'name', 'subject', 'body', 'status'],
                ],
            ]);
    }

    public function test_can_submit_new_question(): void
    {
        $topic = QuestionTopic::first();

        $payload = [
            'topic_id' => $topic?->id,
            'name' => 'Warga Bertanya',
            'email' => 'warga@example.com',
            'phone' => '081234567899',
            'subject' => 'Tanya Prosedur Keterangan Domisili',
            'body' => 'Bagaimana prosedur perpanjangan surat keterangan domisili untuk warga pendatang?',
        ];

        $response = $this->postJson('/api/v1/questions', $payload);

        $response->assertCreated()
            ->assertJsonPath('data.subject', $payload['subject']);

        $this->assertDatabaseHas('questions', [
            'email' => 'warga@example.com',
            'subject' => 'Tanya Prosedur Keterangan Domisili',
        ]);
    }

    public function test_can_fetch_faqs(): void
    {
        $response = $this->getJson('/api/v1/faqs');

        $response->assertOk()
            ->assertJsonStructure([
                'data' => [
                    '*' => ['id', 'question', 'answer', 'sort_order'],
                ],
            ]);
    }

    public function test_api_validation_supports_indonesian_language(): void
    {
        $response = $this->withHeaders(['Accept-Language' => 'id'])
            ->postJson('/api/v1/questions', []);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['name', 'email', 'subject', 'body']);

        $nameError = $response->json('errors.name.0');
        $this->assertTrue(str_contains(strtolower($nameError), 'wajib diisi') || str_contains(strtolower($nameError), 'harus diisi'));
    }

    public function test_api_validation_supports_english_language(): void
    {
        $response = $this->withHeaders(['Accept-Language' => 'en'])
            ->postJson('/api/v1/questions', []);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['name', 'email', 'subject', 'body']);

        $nameError = $response->json('errors.name.0');
        $this->assertTrue(str_contains(strtolower($nameError), 'required'));
    }

    public function test_api_supports_query_param_language_switch(): void
    {
        $responseEn = $this->postJson('/api/v1/questions?lang=en', []);
        $responseEn->assertStatus(422);
        $nameErrorEn = $responseEn->json('errors.name.0');
        $this->assertTrue(str_contains(strtolower($nameErrorEn), 'required'));

        $responseId = $this->postJson('/api/v1/questions?lang=id', []);
        $responseId->assertStatus(422);
        $nameErrorId = $responseId->json('errors.name.0');
        $this->assertTrue(str_contains(strtolower($nameErrorId), 'wajib diisi') || str_contains(strtolower($nameErrorId), 'harus diisi'));
    }
}
