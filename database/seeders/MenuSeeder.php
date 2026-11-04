<?php

namespace Database\Seeders;

use App\Enums\MenuItemType;
use App\Enums\MenuLocation;
use App\Models\Menu;
use App\Models\MenuItem;
use Illuminate\Database\Seeder;

class MenuSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $headerMenu = Menu::query()->updateOrCreate(
            ['location' => MenuLocation::Header->value],
            [
                'name' => 'Menu Navigasi Utama',
                'is_active' => true,
            ]
        );

        $items = [
            ['label' => 'Beranda', 'url' => '/', 'type' => MenuItemType::Custom, 'sort_order' => 1],
            ['label' => 'Tentang Kami', 'url' => '/tentang-kami', 'type' => MenuItemType::Page, 'sort_order' => 2],
            ['label' => 'Visi & Misi', 'url' => '/visi-misi', 'type' => MenuItemType::Page, 'sort_order' => 3],
            ['label' => 'Berita & Pengumuman', 'url' => '/berita', 'type' => MenuItemType::Custom, 'sort_order' => 4],
            ['label' => 'Tanya Kami', 'url' => '/pertanyaan', 'type' => MenuItemType::Custom, 'sort_order' => 5],
            ['label' => 'FAQ', 'url' => '/faq', 'type' => MenuItemType::Custom, 'sort_order' => 6],
        ];

        foreach ($items as $item) {
            MenuItem::query()->updateOrCreate(
                ['menu_id' => $headerMenu->id, 'label' => $item['label']],
                array_merge($item, ['menu_id' => $headerMenu->id, 'is_active' => true])
            );
        }

        $footerMenu = Menu::query()->updateOrCreate(
            ['location' => MenuLocation::Footer->value],
            [
                'name' => 'Menu Footer',
                'is_active' => true,
            ]
        );

        $footerItems = [
            ['label' => 'Kebijakan Privasi', 'url' => '/kebijakan-privasi', 'type' => MenuItemType::Custom, 'sort_order' => 1],
            ['label' => 'Syarat & Ketentuan', 'url' => '/syarat-ketentuan', 'type' => MenuItemType::Custom, 'sort_order' => 2],
            ['label' => 'Kontak Pengaduan', 'url' => '/kontak', 'type' => MenuItemType::Custom, 'sort_order' => 3],
        ];

        foreach ($footerItems as $fItem) {
            MenuItem::query()->updateOrCreate(
                ['menu_id' => $footerMenu->id, 'label' => $fItem['label']],
                array_merge($fItem, ['menu_id' => $footerMenu->id, 'is_active' => true])
            );
        }
    }
}
