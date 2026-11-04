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
                    ->label(__('Upload File / Image'))
                    ->disk('public')
                    ->directory('media')
                    ->required()
                    ->maxSize(10240) // 10MB
                    ->preserveFilenames()
                    ->columnSpanFull(),
                TextInput::make('file_name')
                    ->label(__('File Name'))
                    ->helperText(__('Auto-filled if left blank')),
                TextInput::make('alt_text')
                    ->label(__('Alternative Text (Alt Text)'))
                    ->helperText(__('Short image description for accessibility')),
                Hidden::make('user_id')
                    ->default(fn () => auth()->id()),
            ]);
    }
}
