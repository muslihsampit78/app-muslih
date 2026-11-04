<?php

namespace App\Filament\Resources\Pages\Tables;

use App\Enums\PageStatus;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Filters\TernaryFilter;
use Filament\Tables\Table;

class PagesTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                ImageColumn::make('image')
                    ->label(__('Banner'))
                    ->disk('public'),
                TextColumn::make('title')
                    ->label(__('Page Title'))
                    ->searchable()
                    ->sortable(),
                TextColumn::make('slug')
                    ->label(__('Slug'))
                    ->searchable()
                    ->color('gray'),
                TextColumn::make('status')
                    ->label(__('Status'))
                    ->badge()
                    ->formatStateUsing(fn ($state) => $state instanceof PageStatus ? $state->label() : PageStatus::tryFrom($state)?->label() ?? $state)
                    ->color(fn ($state) => match ($state instanceof PageStatus ? $state : PageStatus::tryFrom($state)) {
                        PageStatus::Published => 'success',
                        default => 'gray',
                    })
                    ->sortable(),
                IconColumn::make('show_in_menu')
                    ->label(__('Show in Menu'))
                    ->boolean()
                    ->sortable(),
                TextColumn::make('sort_order')
                    ->label(__('Sort Order'))
                    ->sortable(),
                TextColumn::make('updated_at')
                    ->label(__('Last Updated'))
                    ->dateTime('d M Y')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->defaultSort('sort_order', 'asc')
            ->filters([
                SelectFilter::make('status')
                    ->label(__('Filter by Status'))
                    ->options(collect(PageStatus::cases())->mapWithKeys(fn (PageStatus $s) => [$s->value => $s->label()])),
                TernaryFilter::make('show_in_menu')
                    ->label(__('Show in Menu')),
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
