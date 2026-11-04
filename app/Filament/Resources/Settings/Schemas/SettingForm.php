<?php

namespace App\Filament\Resources\Settings\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class SettingForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('group')
                    ->label('Grup')
                    ->options([
                        'general' => 'Umum',
                        'contact' => 'Kontak',
                        'social' => 'Media Sosial',
                        'system' => 'Sistem',
                    ])
                    ->default('general')
                    ->required(),
                TextInput::make('key')
                    ->label('Kunci (Key)')
                    ->required()
                    ->unique(ignoreRecord: true)
                    ->helperText('Contoh: site_name, contact_email'),
                TextInput::make('name')
                    ->label('Nama Label')
                    ->required(),
                Select::make('type')
                    ->label('Tipe Data')
                    ->options([
                        'text' => 'Teks Singkat',
                        'textarea' => 'Teks Panjang',
                        'image' => 'Gambar / Logo',
                        'boolean' => 'Boolean (True/False)',
                        'json' => 'JSON',
                    ])
                    ->default('text')
                    ->reactive()
                    ->required(),
                Textarea::make('value')
                    ->label('Nilai Pengaturan')
                    ->rows(4)
                    ->columnSpanFull(),
                Textarea::make('description')
                    ->label('Keterangan')
                    ->rows(2)
                    ->columnSpanFull(),
            ]);
    }
}
