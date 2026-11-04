<?php

namespace App\Filament\Widgets;

use App\Enums\PostStatus;
use App\Filament\Resources\Posts\PostResource;
use App\Models\Post;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget;
use Illuminate\Contracts\Support\Htmlable;
use Illuminate\Database\Eloquent\Builder;

class LatestPostsWidget extends TableWidget
{
    protected static ?int $sort = 3;

    protected int|string|array $columnSpan = 'full';

    public function getTableHeading(): string|Htmlable|null
    {
        return __('Latest Articles & News');
    }

    public function table(Table $table): Table
    {
        return $table
            ->query(fn (): Builder => Post::query()->with('category')->latest()->limit(5))
            ->columns([
                ImageColumn::make('image')
                    ->label(__('Cover'))
                    ->disk('public')
                    ->circular(),
                TextColumn::make('title')
                    ->label(__('Article Title'))
                    ->limit(50),
                TextColumn::make('category.name')
                    ->label(__('Category'))
                    ->badge()
                    ->color('info'),
                TextColumn::make('status')
                    ->label(__('Status'))
                    ->badge()
                    ->formatStateUsing(fn ($state) => $state instanceof PostStatus ? $state->label() : PostStatus::tryFrom($state)?->label() ?? $state)
                    ->color(fn ($state) => match ($state instanceof PostStatus ? $state : PostStatus::tryFrom($state)) {
                        PostStatus::Published => 'success',
                        PostStatus::Archived => 'danger',
                        default => 'gray',
                    }),
                TextColumn::make('view_count')
                    ->label(__('Views'))
                    ->numeric(),
                TextColumn::make('published_at')
                    ->label(__('Publication Time'))
                    ->dateTime('d M Y H:i'),
            ])
            ->recordUrl(fn (Post $record): string => PostResource::getUrl('edit', ['record' => $record]))
            ->paginated(false);
    }
}
