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
                    ->label('Pratinjau')
                    ->disk('public')
                    ->square(),
                TextColumn::make('file_name')
                    ->label('Nama Berkas')
                    ->searchable()
                    ->sortable()
                    ->copyable()
                    ->copyMessage('Nama file disalin'),
                TextColumn::make('mime_type')
                    ->label('Tipe MIME')
                    ->badge(),
                TextColumn::make('file_size')
                    ->label('Ukuran')
                    ->formatStateUsing(fn ($record) => $record->formatted_size)
                    ->sortable(),
                TextColumn::make('created_at')
                    ->label('Diupload')
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
