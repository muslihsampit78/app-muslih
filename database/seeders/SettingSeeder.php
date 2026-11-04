<?php

namespace Database\Seeders;

use App\Models\Setting;
use Illuminate\Database\Seeder;

class SettingSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $settings = [
            [
                'group' => 'general',
                'key' => 'site_name',
                'name' => 'Nama Instansi / Situs',
                'value' => 'Portal Layanan Publik & Informasi',
                'type' => 'text',
                'description' => 'Nama instansi atau judul utama website/aplikasi',
            ],
            [
                'group' => 'general',
                'key' => 'site_tagline',
                'name' => 'Tagline / Slogan',
                'value' => 'Transparan, Akuntabel, dan Melayani Masyarakat',
                'type' => 'text',
                'description' => 'Slogan singkat instansi',
            ],
            [
                'group' => 'general',
                'key' => 'site_description',
                'name' => 'Deskripsi Situs',
                'value' => 'Portal resmi penyedia informasi publik dan saluran penerimaan pertanyaan/aspirasi masyarakat.',
                'type' => 'textarea',
                'description' => 'Deskripsi ringkas mengenai instansi/portal',
            ],
            [
                'group' => 'general',
                'key' => 'site_logo',
                'name' => 'Logo Instansi',
                'value' => null,
                'type' => 'image',
                'description' => 'Logo instansi format PNG/WebP',
            ],
            [
                'group' => 'contact',
                'key' => 'contact_email',
                'name' => 'Email Kontak',
                'value' => 'kontak@instansi.go.id',
                'type' => 'text',
                'description' => 'Email resmi layanan publik',
            ],
            [
                'group' => 'contact',
                'key' => 'contact_phone',
                'name' => 'Nomor Telepon / WhatsApp',
                'value' => '+62 812-3456-7890',
                'type' => 'text',
                'description' => 'Kontak hotline pelayanan',
            ],
            [
                'group' => 'contact',
                'key' => 'contact_address',
                'name' => 'Alamat Kantor',
                'value' => 'Jl. Protokol No. 45, Kompleks Perkantoran Pemerintah',
                'type' => 'textarea',
                'description' => 'Alamat fisik kantor instansi',
            ],
            [
                'group' => 'social',
                'key' => 'social_facebook',
                'name' => 'Facebook URL',
                'value' => 'https://facebook.com/instansiresmi',
                'type' => 'text',
                'description' => 'Tautan ke halaman Facebook resmi',
            ],
            [
                'group' => 'social',
                'key' => 'social_instagram',
                'name' => 'Instagram URL',
                'value' => 'https://instagram.com/instansiresmi',
                'type' => 'text',
                'description' => 'Tautan ke akun Instagram resmi',
            ],
            [
                'group' => 'social',
                'key' => 'social_youtube',
                'name' => 'YouTube Channel',
                'value' => 'https://youtube.com/@instansiresmi',
                'type' => 'text',
                'description' => 'Tautan ke channel YouTube resmi',
            ],
        ];

        foreach ($settings as $setting) {
            Setting::query()->updateOrCreate(['key' => $setting['key']], $setting);
        }
    }
}
