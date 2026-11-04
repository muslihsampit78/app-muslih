<?php

namespace App\Filament\Resources\Slides\Schemas;

use Filament\Forms\Components\DatePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class SlideForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Informasi Slide')
                    ->components([
                        TextInput::make('title')
                            ->label('Judul Slide')
                            ->required()
                            ->maxLength(255),
                        TextInput::make('link_url')
                            ->label('Tautan URL (Opsional)')
                            ->placeholder('https://...')
                            ->url(),
                        Textarea::make('description')
                            ->label('Deskripsi / Keterangan')
                            ->rows(2)
                            ->columnSpanFull(),
                    ])
                    ->columns(2),

                Section::make('Media & Penjadwalan')
                    ->components([
                        FileUpload::make('image')
                            ->label('Gambar Banner Slide')
                            ->image()
                            ->disk('public')
                            ->directory('slides')
                            ->required()
                            ->maxSize(3072)
                            ->columnSpanFull(),
                        DatePicker::make('start_date')
                            ->label('Tanggal Mulai Tayang'),
                        DatePicker::make('end_date')
                            ->label('Tanggal Selesai Tayang'),
                        TextInput::make('sort_order')
                            ->label('Urutan')
                            ->numeric()
                            ->default(0),
                        Toggle::make('is_active')
                            ->label('Status Aktif')
                            ->default(true),
                    ])
                    ->columns(2),
            ]);
    }
}
