<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            [
                'name' => 'Berita & Kebijakan',
                'slug' => 'berita-kebijakan',
                'description' => 'Informasi kebijakan terbaru dan rilis pers resmi instansi.',
                'icon' => 'heroicon-o-newspaper',
                'sort_order' => 1,
                'is_active' => true,
            ],
            [
                'name' => 'Layanan Publik',
                'slug' => 'layanan-publik',
                'description' => 'Panduan dan alur pelayanan administrasi bagi masyarakat.',
                'icon' => 'heroicon-o-user-group',
                'sort_order' => 2,
                'is_active' => true,
            ],
            [
                'name' => 'Pengumuman Resmi',
                'slug' => 'pengumuman',
                'description' => 'Pengumuman resmi, seleksi, dan edaran dinas.',
                'icon' => 'heroicon-o-megaphone',
                'sort_order' => 3,
                'is_active' => true,
            ],
            [
                'name' => 'Kegiatan & Agenda',
                'slug' => 'kegiatan-agenda',
                'description' => 'Dokumentasi kegiatan dan jadwal agenda mendatang.',
                'icon' => 'heroicon-o-calendar',
                'sort_order' => 4,
                'is_active' => true,
            ],
        ];

        foreach ($categories as $cat) {
            Category::query()->updateOrCreate(['slug' => $cat['slug']], $cat);
        }
    }
}
