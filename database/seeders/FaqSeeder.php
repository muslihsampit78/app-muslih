<?php

namespace Database\Seeders;

use App\Models\Faq;
use App\Models\QuestionTopic;
use Illuminate\Database\Seeder;

class FaqSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $topicKtp = QuestionTopic::where('slug', 'layanan-kependudukan')->first();
        $topicIzin = QuestionTopic::where('slug', 'perizinan-usaha')->first();
        $topicBansos = QuestionTopic::where('slug', 'bantuan-sosial')->first();

        $faqs = [
            [
                'topic_id' => $topicKtp?->id,
                'question' => 'Berapa lama proses pembuatan dokumen administrasi sipil?',
                'answer' => '<p>Waktu penerbitan dokumen administrasi berkisar antara 1 hingga 3 hari kerja sejak kelengkapan berkas dinyatakan valid oleh petugas verifikasi kami.</p>',
                'sort_order' => 1,
                'is_active' => true,
            ],
            [
                'topic_id' => $topicKtp?->id,
                'question' => 'Apakah ada pungutan biaya untuk pengurusan surat pengantar?',
                'answer' => '<p>Seluruh pelayanan administrasi pengantar dan surat keterangan tidak dipungut biaya apapun (<strong>Gratis 100%</strong>).</p>',
                'sort_order' => 2,
                'is_active' => true,
            ],
            [
                'topic_id' => $topicIzin?->id,
                'question' => 'Dokumen apa saja yang diperlukan untuk izin usaha mikro?',
                'answer' => '<p>Persyaratan mencakup: KTP pemilik usaha, NPWP, foto tempat usaha/produk, serta surat keterangan domisili usaha dari kelurahan setempat.</p>',
                'sort_order' => 3,
                'is_active' => true,
            ],
            [
                'topic_id' => $topicBansos?->id,
                'question' => 'Bagaimana cara mengecek status kepesertaan bantuan sosial?',
                'answer' => '<p>Anda dapat mengecek status kepesertaan melalui menu Tanya Kami pada aplikasi ini dengan menyertakan Nomor Induk Kependudukan (NIK) Anda.</p>',
                'sort_order' => 4,
                'is_active' => true,
            ],
        ];

        foreach ($faqs as $faq) {
            Faq::query()->updateOrCreate(['question' => $faq['question']], $faq);
        }
    }
}
