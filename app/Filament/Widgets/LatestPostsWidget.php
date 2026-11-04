<?php

namespace App\Filament\Widgets;

use App\Enums\PostStatus;
use App\Filament\Resources\Posts\PostResource;
use App\Models\Post;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget;
use Illuminate\Database\Eloquent\Builder;

class LatestPostsWidget extends TableWidget
{
    protected static ?int $sort = 3;

    protected static ?string $heading = 'Artikel & Berita Terbaru';

    protected int|string|array $columnSpan = 'full';

    public function table(Table $table): Table
    {
        return $table
            ->query(fn (): Builder => Post::query()->with('category')->latest()->limit(5))
            ->columns([
                ImageColumn::make('image')
                    ->label('Sampul')
                    ->disk('public')
                    ->circular(),
                TextColumn::make('title')
                    ->label('Judul Artikel')
                    ->limit(50),
                TextColumn::make('category.name')
                    ->label('Kategori')
                    ->badge()
                    ->color('info'),
                TextColumn::make('status')
                    ->label('Status')
                    ->badge()
                    ->formatStateUsing(fn ($state) => $state instanceof PostStatus ? $state->label() : PostStatus::tryFrom($state)?->label() ?? $state)
                    ->color(fn ($state) => match ($state instanceof PostStatus ? $state : PostStatus::tryFrom($state)) {
                        PostStatus::Published => 'success',
                        PostStatus::Archived => 'danger',
                        default => 'gray',
                    }),
                TextColumn::make('view_count')
                    ->label('Dilihat')
                    ->numeric(),
                TextColumn::make('published_at')
                    ->label('Waktu Publikasi')
                    ->dateTime('d M Y H:i'),
            ])
            ->recordUrl(fn (Post $record): string => PostResource::getUrl('edit', ['record' => $record]))
            ->paginated(false);
    }
}
