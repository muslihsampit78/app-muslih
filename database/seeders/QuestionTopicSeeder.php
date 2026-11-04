<?php

namespace Database\Seeders;

use App\Models\QuestionTopic;
use Illuminate\Database\Seeder;

class QuestionTopicSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $topics = [
            [
                'name' => 'Layanan Kependudukan & Administrasi',
                'slug' => 'layanan-kependudukan',
                'description' => 'Pertanyaan seputar berkas identitas, surat keterangan, dan administrasi sipil.',
                'icon' => 'heroicon-o-identification',
                'sort_order' => 1,
                'is_active' => true,
            ],
            [
                'name' => 'Perizinan Usaha & Bangunan',
                'slug' => 'perizinan-usaha',
                'description' => 'Konsultasi izin berusaha, rekomendasi dinas, dan pengurusan sertifikasi.',
                'icon' => 'heroicon-o-building-office',
                'sort_order' => 2,
                'is_active' => true,
            ],
            [
                'name' => 'Pengaduan Sarana & Fasilitas Publik',
                'slug' => 'pengaduan-fasilitas',
                'description' => 'Laporan perbaikan jalan, penerangan, lingkungan, dan fasilitas umum.',
                'icon' => 'heroicon-o-exclamation-triangle',
                'sort_order' => 3,
                'is_active' => true,
            ],
            [
                'name' => 'Bantuan Sosial & Kesejahteraan',
                'slug' => 'bantuan-sosial',
                'description' => 'Pendaftaran program bansos, kriteria penerima, dan jadwal distribusi.',
                'icon' => 'heroicon-o-heart',
                'sort_order' => 4,
                'is_active' => true,
            ],
        ];

        foreach ($topics as $topic) {
            QuestionTopic::query()->updateOrCreate(['slug' => $topic['slug']], $topic);
        }
    }
}
