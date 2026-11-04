<?php

namespace App\Filament\Resources\Media\Schemas;

use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class MediaForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                FileUpload::make('file_path')
                    ->label('Unggah Berkas / Gambar')
                    ->disk('public')
                    ->directory('media')
                    ->required()
                    ->maxSize(10240) // 10MB
                    ->preserveFilenames()
                    ->columnSpanFull(),
                TextInput::make('file_name')
                    ->label('Nama Berkas')
                    ->helperText('Otomatis terisi jika dikosongkan'),
                TextInput::make('alt_text')
                    ->label('Teks Alternatif (Alt Text)')
                    ->helperText('Deskripsi singkat gambar untuk aksesibilitas'),
                Hidden::make('user_id')
                    ->default(fn () => auth()->id()),
            ]);
    }
}
