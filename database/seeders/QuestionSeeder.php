<?php

namespace Database\Seeders;

use App\Enums\AnswerStatus;
use App\Enums\QuestionStatus;
use App\Models\Question;
use App\Models\QuestionAnswer;
use App\Models\QuestionTopic;
use App\Models\User;
use Illuminate\Database\Seeder;

class QuestionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $admin = User::first();
        $topicKtp = QuestionTopic::where('slug', 'layanan-kependudukan')->first();
        $topicFasilitas = QuestionTopic::where('slug', 'pengaduan-fasilitas')->first();

        // Sample Answered Question
        $q1 = Question::query()->updateOrCreate(
            ['subject' => 'Jam operasional pelayanan loket di hari kerja'],
            [
                'topic_id' => $topicKtp?->id,
                'name' => 'Budi Santoso',
                'email' => 'budi.santoso@example.com',
                'phone' => '081234567891',
                'body' => 'Selamat pagi, mohon info jam operasional loket pelayanan tatap muka pada hari Senin sampai Jumat buka pukul berapa saja?',
                'status' => QuestionStatus::Answered,
                'ip_address' => '127.0.0.1',
            ]
        );

        QuestionAnswer::query()->updateOrCreate(
            ['question_id' => $q1->id],
            [
                'user_id' => $admin?->id ?? 1,
                'body' => '<p>Halo Bapak Budi, loket pelayanan tatap muka kami buka setiap hari Senin s.d. Kamis pukul 08.00 - 15.30 WIB (istirahat 12.00 - 13.00), dan hari Jumat pukul 08.00 - 15.00 WIB (istirahat 11.30 - 13.00). Terima kasih.</p>',
                'status' => AnswerStatus::Published,
                'is_published' => true,
                'answered_at' => now()->subDay(),
            ]
        );

        // Sample Pending Question
        Question::query()->updateOrCreate(
            ['subject' => 'Lampu penerangan jalan padam di Jl. Melati'],
            [
                'topic_id' => $topicFasilitas?->id,
                'name' => 'Siti Aminah',
                'email' => 'siti.aminah@example.com',
                'phone' => '081398765432',
                'body' => 'Mohon ditindaklanjuti, lampu penerangan jalan umum di Jl. Melati RT 03 sudah 3 hari padam sehingga jalan gelap saat malam hari.',
                'status' => QuestionStatus::Pending,
                'ip_address' => '127.0.0.1',
            ]
        );
    }
}
