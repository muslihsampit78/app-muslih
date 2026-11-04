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
            Stat::make(__('Public Articles'), number_format($publishedPosts))
                ->description(__('Active published articles'))
                ->descriptionIcon(Heroicon::OutlinedDocumentText)
                ->color('success'),

            Stat::make(__('Pending Questions'), number_format($pendingQuestions))
                ->description(__('Needs admin response'))
                ->descriptionIcon(Heroicon::OutlinedClock)
                ->color($pendingQuestions > 0 ? 'warning' : 'gray'),

            Stat::make(__('Answered Questions'), number_format($answeredQuestions))
                ->description(__('Aspirations resolved'))
                ->descriptionIcon(Heroicon::OutlinedCheckCircle)
                ->color('info'),

            Stat::make(__('Total Article Readers'), number_format($totalViews))
                ->description(__('Accumulated readers'))
                ->descriptionIcon(Heroicon::OutlinedEye)
                ->color('primary'),
        ];
    }
}
