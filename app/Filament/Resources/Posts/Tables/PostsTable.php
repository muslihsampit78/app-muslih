<?php

namespace App\Filament\Resources\Posts\Tables;

use App\Enums\PostStatus;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Filters\TernaryFilter;
use Filament\Tables\Table;

class PostsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                ImageColumn::make('image')
                    ->label(__('Cover'))
                    ->disk('public')
                    ->circular()
                    ->defaultImageUrl('/placeholder.png'),
                TextColumn::make('title')
                    ->label(__('Article Title'))
                    ->searchable()
                    ->sortable()
                    ->limit(40)
                    ->description(fn ($record): ?string => $record->summary ? substr($record->summary, 0, 50).'...' : null),
                TextColumn::make('category.name')
                    ->label(__('Category'))
                    ->badge()
                    ->color('info')
                    ->sortable()
                    ->searchable(),
                TextColumn::make('status')
                    ->label(__('Status'))
                    ->badge()
                    ->formatStateUsing(fn ($state) => $state instanceof PostStatus ? $state->label() : PostStatus::tryFrom($state)?->label() ?? $state)
                    ->color(fn ($state) => match ($state instanceof PostStatus ? $state : PostStatus::tryFrom($state)) {
                        PostStatus::Published => 'success',
                        PostStatus::Archived => 'danger',
                        default => 'gray',
                    })
                    ->sortable(),
                IconColumn::make('is_featured')
                    ->label(__('Headline'))
                    ->boolean()
                    ->sortable(),
                TextColumn::make('published_at')
                    ->label(__('Published At'))
                    ->dateTime('d M Y H:i')
                    ->sortable(),
                TextColumn::make('view_count')
                    ->label(__('Views'))
                    ->numeric()
                    ->sortable(),
            ])
            ->defaultSort('created_at', 'desc')
            ->filters([
                SelectFilter::make('category_id')
                    ->label(__('Filter by Category'))
                    ->relationship('category', 'name'),
                SelectFilter::make('status')
                    ->label(__('Filter by Status'))
                    ->options(collect(PostStatus::cases())->mapWithKeys(fn (PostStatus $s) => [$s->value => $s->label()])),
                TernaryFilter::make('is_featured')
                    ->label(__('Headline Article')),
            ])
            ->recordActions([
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
