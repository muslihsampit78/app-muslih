<?php

namespace App\Filament\Widgets;

use App\Enums\PostStatus;
use App\Enums\QuestionStatus;
use App\Models\Post;
use App\Models\Question;
use Filament\Support\Icons\Heroicon;
use Filament\Widgets\StatsOverviewWidget as BaseStatsOverviewWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverviewWidget extends BaseStatsOverviewWidget
{
    protected static ?int $sort = 1;

    protected function getStats(): array
    {
        $publishedPosts = Post::where('status', PostStatus::Published->value)->count();
        $pendingQuestions = Question::where('status', QuestionStatus::Pending->value)->count();
        $answeredQuestions = Question::where('status', QuestionStatus::Answered->value)->count();
        $totalViews = Post::sum('view_count');

        return [
            Stat::make('Artikel Publik', number_format($publishedPosts))
                ->description('Artikel yang aktif tayang')
                ->descriptionIcon(Heroicon::OutlinedDocumentText)
                ->color('success'),

            Stat::make('Pertanyaan Menunggu', number_format($pendingQuestions))
                ->description('Perlu respon admin')
                ->descriptionIcon(Heroicon::OutlinedClock)
                ->color($pendingQuestions > 0 ? 'warning' : 'gray'),

            Stat::make('Pertanyaan Terjawab', number_format($answeredQuestions))
                ->description('Aspirasi terselesaikan')
                ->descriptionIcon(Heroicon::OutlinedCheckCircle)
                ->color('info'),

            Stat::make('Total Pembaca Artikel', number_format($totalViews))
                ->description('Akumulasi pembaca')
                ->descriptionIcon(Heroicon::OutlinedEye)
                ->color('primary'),
        ];
    }
}
