<?php

namespace App\Notifications;

use App\Models\Question;
use App\Models\QuestionAnswer;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class QuestionAnsweredNotification extends Notification
{
    use Queueable;

    public function __construct(
        public Question $question,
        public QuestionAnswer $answer
    ) {}

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['mail'];
    }

    /**
     * Get the mail representation of the notification.
     */
    public function toMail(object $notifiable): MailMessage
    {
        return (new MailMessage)
            ->subject('Tanggapan atas Pertanyaan Anda: '.$this->question->subject)
            ->greeting('Halo, '.$this->question->name.'!')
            ->line('Pertanyaan yang Anda ajukan melalui portal kami telah dijawab oleh admin/petugas:')
            ->line('**Pertanyaan:**')
            ->line('> '.$this->question->body)
            ->line('**Jawaban/Tanggapan:**')
            ->line($this->answer->body)
            ->line('Terima kasih telah berpartisipasi dan menghubungi kami.');
    }
}
