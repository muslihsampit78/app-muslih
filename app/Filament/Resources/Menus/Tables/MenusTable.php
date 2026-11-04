<?php

namespace App\Filament\Resources\Menus\Tables;

use App\Enums\MenuLocation;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Filters\TernaryFilter;
use Filament\Tables\Table;

class MenusTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('name')
                    ->label(__('Menu Name'))
                    ->searchable()
                    ->sortable(),
                TextColumn::make('location')
                    ->label(__('Location'))
                    ->badge()
                    ->formatStateUsing(fn ($state) => $state instanceof MenuLocation ? $state->label() : MenuLocation::tryFrom($state)?->label() ?? $state)
                    ->color('info')
                    ->sortable(),
                TextColumn::make('items_count')
                    ->label(__('Item Count'))
                    ->counts('items')
                    ->badge()
                    ->color('gray'),
                IconColumn::make('is_active')
                    ->label(__('Active Status'))
                    ->boolean()
                    ->sortable(),
                TextColumn::make('updated_at')
                    ->label(__('Last Updated'))
                    ->dateTime('d M Y')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                SelectFilter::make('location')
                    ->label(__('Filter by Location'))
                    ->options(collect(MenuLocation::cases())->mapWithKeys(fn (MenuLocation $l) => [$l->value => $l->label()])),
                TernaryFilter::make('is_active')
                    ->label(__('Active Status')),
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
