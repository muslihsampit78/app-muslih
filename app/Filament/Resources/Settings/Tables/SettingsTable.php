<?php

namespace App\Filament\Resources\Settings\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;

class SettingsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('group')
                    ->label(__('Group'))
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'general' => 'info',
                        'contact' => 'success',
                        'social' => 'warning',
                        default => 'gray',
                    })
                    ->searchable()
                    ->sortable(),
                TextColumn::make('name')
                    ->label(__('Label Name'))
                    ->searchable()
                    ->sortable(),
                TextColumn::make('key')
                    ->label(__('Key'))
                    ->searchable()
                    ->copyable()
                    ->color('gray')
                    ->fontFamily('mono'),
                TextColumn::make('value')
                    ->label(__('Value'))
                    ->limit(40)
                    ->searchable(),
                TextColumn::make('type')
                    ->label(__('Type'))
                    ->badge(),
                TextColumn::make('updated_at')
                    ->label(__('Last Updated'))
                    ->dateTime('d M Y H:i')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                SelectFilter::make('group')
                    ->label(__('Filter by Group'))
                    ->options([
                        'general' => __('General'),
                        'contact' => __('Contact'),
                        'social' => __('Social Media'),
                        'system' => __('System'),
                    ]),
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
