<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AdminPanelTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed();
    }

    public function test_guest_is_redirected_to_login(): void
    {
        $response = $this->get('/admin');

        $response->assertRedirect('/admin/login');
    }

    public function test_login_page_is_accessible(): void
    {
        $response = $this->get('/admin/login');

        $response->assertOk();
    }

    public function test_admin_can_access_dashboard_and_resources(): void
    {
        $admin = User::where('email', 'admin@muslih.id')->first();
        $this->assertNotNull($admin);

        $this->actingAs($admin)
            ->get('/admin')
            ->assertOk();

        $this->actingAs($admin)
            ->get('/admin/posts')
            ->assertOk();

        $this->actingAs($admin)
            ->get('/admin/questions')
            ->assertOk();

        $this->actingAs($admin)
            ->get('/admin/settings')
            ->assertOk();
    }
}
