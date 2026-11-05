<?php

namespace Tests\Feature;

use Tests\TestCase;

class ExampleTest extends TestCase
{
    /**
     * Test that the homepage serves successfully.
     */
    public function test_the_application_returns_a_successful_response(): void
    {
        $response = $this->get('/');

        $response->assertStatus(200);
    }

    /**
     * Test that Flutter SPA routes serve successfully.
     */
    public function test_flutter_spa_routes_serve_successfully(): void
    {
        $response = $this->get('/posts');
        $response->assertStatus(200);

        $response = $this->get('/questions');
        $response->assertStatus(200);

        $response = $this->get('/faq');
        $response->assertStatus(200);
    }
}
