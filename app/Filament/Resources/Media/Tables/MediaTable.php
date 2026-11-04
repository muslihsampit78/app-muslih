<?php

namespace App\Filament\Resources\Media\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\ImageColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class MediaTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                ImageColumn::make('file_path')
                    ->label(__('Preview'))
                    ->disk('public')
                    ->square(),
                TextColumn::make('file_name')
                    ->label(__('File Name'))
                    ->searchable()
                    ->sortable()
                    ->copyable()
                    ->copyMessage(__('File name copied')),
                TextColumn::make('mime_type')
                    ->label(__('MIME Type'))
                    ->badge(),
                TextColumn::make('file_size')
                    ->label(__('File Size'))
                    ->formatStateUsing(fn ($record) => $record->formatted_size)
                    ->sortable(),
                TextColumn::make('created_at')
                    ->label(__('Uploaded At'))
                    ->dateTime('d M Y H:i')
                    ->sortable(),
            ])
            ->defaultSort('created_at', 'desc')
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
