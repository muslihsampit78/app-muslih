<?php

namespace App\Filament\Resources\Menus\Schemas;

use App\Enums\MenuItemType;
use App\Enums\MenuLocation;
use Filament\Forms\Components\Repeater;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class MenuForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make('Informasi Menu')
                    ->components([
                        TextInput::make('name')
                            ->label('Nama Menu')
                            ->required()
                            ->maxLength(255)
                            ->placeholder('cth: Menu Utama Header'),
                        Select::make('location')
                            ->label('Lokasi Menu')
                            ->options(collect(MenuLocation::cases())->mapWithKeys(fn (MenuLocation $loc) => [
                                $loc->value => $loc->label(),
                            ]))
                            ->default(MenuLocation::Header->value)
                            ->required(),
                        Toggle::make('is_active')
                            ->label('Status Aktif')
                            ->default(true),
                    ])
                    ->columns(3),

                Section::make('Daftar Item Menu')
                    ->components([
                        Repeater::make('items')
                            ->label('Item-item Navigasi')
                            ->relationship('items')
                            ->orderColumn('sort_order')
                            ->schema([
                                TextInput::make('label')
                                    ->label('Teks Label')
                                    ->required(),
                                Select::make('type')
                                    ->label('Tipe Tautan')
                                    ->options(collect(MenuItemType::cases())->mapWithKeys(fn (MenuItemType $t) => [
                                        $t->value => $t->label(),
                                    ]))
                                    ->default(MenuItemType::Custom->value)
                                    ->required(),
                                TextInput::make('url')
                                    ->label('Tautan URL / Path')
                                    ->placeholder('/tentang-kami atau https://...')
                                    ->required(),
                                Toggle::make('is_active')
                                    ->label('Aktif')
                                    ->default(true),
                            ])
                            ->columns(4)
                            ->collapsible()
                            ->itemLabel(fn (array $state): ?string => $state['label'] ?? null),
                    ]),
            ]);
    }
}
