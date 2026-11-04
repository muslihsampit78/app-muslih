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
                    ->label('Grup')
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
                    ->label('Nama Label')
                    ->searchable()
                    ->sortable(),
                TextColumn::make('key')
                    ->label('Kunci')
                    ->searchable()
                    ->copyable()
                    ->color('gray')
                    ->fontFamily('mono'),
                TextColumn::make('value')
                    ->label('Nilai')
                    ->limit(40)
                    ->searchable(),
                TextColumn::make('type')
                    ->label('Tipe')
                    ->badge(),
                TextColumn::make('updated_at')
                    ->label('Terakhir Diperbarui')
                    ->dateTime('d M Y H:i')
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                SelectFilter::make('group')
                    ->label('Filter Grup')
                    ->options([
                        'general' => 'Umum',
                        'contact' => 'Kontak',
                        'social' => 'Media Sosial',
                        'system' => 'Sistem',
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
